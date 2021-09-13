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
        default:
            fatalError("targetLanguage : \(targetLanguage), destinationLanguage : \(destinationLanguage), other than swift, all transpilers are being implemented.")
    }
}

public func isValid(source: String, for language: Language) -> Bool {
    true
}

public func preprocess(source: String, for language: Language) -> String {
    // WARN: Code generation based on AST will not work properly if syntax is replaced ahead of time
    switch language {
        case .kotlin:
        return source
        case .python:
            return source
        default:
            return source
    }
}

// TODO: SHOULD NOT BE USED, JUST FOR PROTOTYPING. LET'S SAY print("let is good!")
public func finalize(source: String, for language: Language) -> String {
    switch language {
        case .kotlin:
            return source
                .replacingOccurrences(of: "var", with: "var")
                .replacingOccurrences(of: "let", with: "val")
                .replacingOccurrences(of: "init", with: "constructor")
                .replacingOccurrences(of: "self", with: "this")
                .replacingOccurrences(of: "->", with: ":")
                .replacingOccurrences(of: "??", with: "?:")
                .replacingOccurrences(of: "func", with: "fun")
                .replacingOccurrences(of: "protocol", with: "interface")
                .replacingOccurrences(of: "nil", with: "null")
                .replacingOccurrences(of: "@objc", with: "")
                .replacingOccurrences(of: "@objcMembers", with: "")
                .replacingOccurrences(of: "AnyClass", with: "Any")
                .replacingOccurrences(of: "AnyClass", with: "Any")
                
        case .python:
            return source
                .replacingOccurrences(of: "print(\"", with: "print(f\"")
                .replacingOccurrences(of: "else if", with: "elif")
                .replacingOccurrences(of: "true", with: "True")
                .replacingOccurrences(of: "false", with: "False")
//                .replacingOccurrences(of: "let", with: "")
//                .replacingOccurrences(of: "var", with: "")
        default:
            return source
    }
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
