//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let res = transpile(from: swiftSource)
print(res)

func transpile(from source: String, to language: Language? = nil) -> String {
    guard let language = language == nil ? recognizeLanguage(from: source) : language
        else { return source }

    let (_, indentedSource) = indent(source: source)
    let AST = try! SyntaxParser.parse(source: indentedSource.trim(for:language))
    let destinationCode = generate(from: AST, to: language)
    
    return destinationCode
}

func generate(from AST: SourceFileSyntax, to language: Language) -> String {
    let transformedSyntax = Visitor(language: language).visit(AST)
    let sourceCode = transformedSyntax.description
        
    return sourceCode
}
