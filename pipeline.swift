//
//  pipeline.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/19.
//

import Foundation
import SwiftSyntax

public func transpile(_ source: String, to language: Language? = nil) -> String {
    guard let language = language == nil ? recognizeLanguage(from: source) : language
        else { return source }
    guard case let isValid = validCheck(source:source, for: language), isValid == true
        else { return source }

    let preprocessedSource = preprocess(source: source, for: language)
    let (_, indentedSource) = indent(source: preprocessedSource, indentType: .space4)
    let AST = try! SyntaxParser.parse(source: indentedSource)
    let generatedCode = generateCode(from: AST, for: language)
    
    return generatedCode
}

public func generateCode(from AST: SourceFileSyntax, for language: Language) -> String {
    finalize(
        source: CodeGenerator(from: AST, for: language).generate(),
        for: language
    )
}

public func validCheck(source: String, for language: Language) -> Bool {
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

