//
//  pipeline.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/19.
//

import Foundation
import SwiftSyntax

public func transpile(_ source: String) -> String {
    let (targetLanguage, destinationLanguage) = recognizeLanguage(from: source)

    let preprocessedSource = preprocess(source: source, for: destinationLanguage)
    let pureCode = takeCode(from:preprocessedSource)
    let indentedSource = indent(source: pureCode, indentType: .space4)
    
    let generatedCode = generateCode(source: indentedSource,
                                     from: targetLanguage,
                                     to: destinationLanguage)
    
    return generatedCode
}

public func generateCode(source: String,
                         from targetLanguage: Language,
                         to destinationLanguage: Language) -> String {
    guard isValid(source:source, for: targetLanguage)
        else { return source }
    print("targetLanguage : \(targetLanguage), destinationLanguage : \(destinationLanguage)")
    
    switch targetLanguage {
        case .swift:
            let swiftAST = try! SyntaxParser.parse(source: source)
            let generatedCode = CodeGenerator(from: swiftAST, to: destinationLanguage).generate()
            return finalize(
                source: generatedCode,
                for: destinationLanguage
            )
            
        case .kotlin:
            let kotlinAST = kotlinAST(from: source)
            if destinationLanguage == .swift {
                return finalize(
                    source: source,
                    for: .swift
                )
            } else {
                let swiftCode = CodeGenerator(from: kotlinAST, to: .swift).generate()
                return generateCode(source: swiftCode,
                                    from: .swift,
                                    to: destinationLanguage)
            }
        case .python:
            let pythonAST = pythonAST(from: source)
            if destinationLanguage == .swift {
                return finalize(
                    source: source,
                    for: .swift
                )
            } else {
                let swiftCode = CodeGenerator(from: pythonAST, to: .swift).generate()
                return generateCode(source: swiftCode,
                                    from: .swift,
                                    to: destinationLanguage)
            }
        case .javascript:
            let javascriptAST = javascriptAST(from: source)
            if destinationLanguage == .swift {
                return finalize(
                    source: source,
                    for: .swift
                )
            } else {
                let swiftCode = CodeGenerator(from: javascriptAST, to: .swift).generate()
                return generateCode(source: swiftCode,
                                    from: .swift,
                                    to: destinationLanguage)
            }
        default:
            fatalError("targetLanguage : \(targetLanguage), destinationLanguage : \(destinationLanguage), other than swift, all transpilers are being implemented.")
    }
}


// TODO: Remove
public typealias JavascriptAST = SourceFileSyntax
public func javascriptAST(from source: String) -> JavascriptAST {
    return try! SyntaxParser.parse(source: source)
}

// TODO: Remove
public typealias KotlinAST = SourceFileSyntax
public func kotlinAST(from source: String) -> KotlinAST {
    return try! SyntaxParser.parse(source: source)
}

// TODO: Remove
public typealias PythonAST = SourceFileSyntax
public func pythonAST(from source: String) -> PythonAST {
    return try! SyntaxParser.parse(source: source)
}
