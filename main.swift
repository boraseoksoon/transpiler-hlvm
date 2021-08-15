//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let source5 = """
python {
    var arr3 = [Int(0)]
    var arr = [Character("a"), Character("b"), Character("c")]
}
"""

let res = transpile(source5)
print("*********************")
print("*********************")
print("** code generation **")
print(res)

//let (_, indentedSource) = indent(source: source5)
//print("take")
//
//print(indentedSource)

func transpile(_ source: String, to language: Language? = nil) -> String {
    guard let language = language == nil ? recognizeLanguage(from: source) : language
        else { return source }
    guard case let isValid = validCheck(source:source, for: language), isValid == true
        else { return source }

    let preprocessedSource = preprocess(source: source, for: language)
    let (_, indentedSource) = indent(source: preprocessedSource)
    let AST = try! SyntaxParser.parse(source: indentedSource)
    let generatedCode = generateCode(from: AST, for: language)
    
    return generatedCode
}

func generateCode(from AST: SourceFileSyntax, for language: Language) -> String {
    finalize(source:CodeGenerator(from: AST, for: language).generate(), for: language)
}

func validCheck(source: String, for language: Language) -> Bool {
    true
}

func preprocess(source: String, for language: Language) -> String {
    source
}

func finalize(source: String, for language: Language) -> String {
    switch language {
        case .python:
            return source
                .replacingOccurrences(of: "print(\"", with: "print(f\"")
                .replacingOccurrences(of: "else if", with: "elif")
                .replacingOccurrences(of: "true", with: "True")
                .replacingOccurrences(of: "false", with: "False")
        default:
            return source
    }
}
