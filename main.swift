//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let source = """
kotlin {
    func double(x: Int, y: Int) -> Int {
        return y * x
    }

    let x = 20
    let y = 30
    let result = double(x:x, y:y)
    print("\\(x) * \\(y) : \\(result)")
}
"""

let transformedCode = transpile(source, to: .kotlin)



print("*********************")
print("*********************")
print("** code generation **")
print("*********************")
print("*********************")
print("")
print(transformedCode)
print("")

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
    finalize(source: CodeGenerator(from: AST, for: language).generate(),
             for: language)
}

func validCheck(source: String, for language: Language) -> Bool {
    true
}

func preprocess(source: String, for language: Language) -> String {
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
            // bug // .replacingOccurrences(of: "!", with: "!!")
        case .python:
            return source
        default:
            return source
    }

}

func finalize(source: String, for language: Language) -> String {
    switch language {
        case .kotlin:
            return source
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
