//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let sourceCode = swiftSource
let destinationLanguage = Language.python

let AST = try SyntaxParser.parse(source: sourceCode.trim(for:destinationLanguage))
let destinationCode = generate(from: AST, to:destinationLanguage)

print("result >>")
print(destinationCode)

print("********************************************")

func generate(from AST: SourceFileSyntax, to language: Language) -> String {
    let transformedSyntax = Visitor(language: language).visit(AST)
    let sourceCode = transformedSyntax.description
        
    return sourceCode
}
