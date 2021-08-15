//
//  CodeGeneratorFunction.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/15.
//

import Foundation
import SwiftSyntax

func generateSyntax(from token: TokenSyntax, to language: Language) -> TokenSyntax {
//    print("generated token : \(token)")
//    print("generated token.tokenKind : \(token.tokenKind)")
//    print("generated token.tokens : \(token.tokens.map { $0.text })")
    
    switch language {
        case .python:
            return generatePythonSyntax(from: token)
        case .kotlin:
            return generateKotlinSyntax(from: token)
        default:
            fatalError("\(language) is not implemented for code generation")
    }
}

func generateKotlinSyntax(from token: TokenSyntax) -> TokenSyntax {
    token.withKind(.stringLiteral("kotlin"))
}

func generatePythonSyntax(from token: TokenSyntax) -> TokenSyntax {
    switch token.tokenKind {
        case .funcKeyword:
            return token.withKind(.identifier("def"))
        case .structKeyword:
            return token.withKind(.classKeyword)
        case .leftBrace:
            return token
            // return token.withKind(.colon).withoutTrivia()
        case .rightBrace:
            return token
                // token.withKind(.unknown("")).withoutTrivia().withLeadingTrivia(Trivia.newlines(0))
        case .letKeyword:
            return token.withKind(.unknown(""))
                .withTrailingTrivia(Trivia.spaces(0))
        case .varKeyword:
            return token.withKind(.unknown(""))
                .withTrailingTrivia(Trivia.spaces(0))
        default:
             return token // token.withKind(token.tokenKind)

//            let msg = """
//            no token text : \(token.text) token Kind : \(token.tokenKind)!
//            """
//
//            fatalError(msg)
    }
}


func makeArray(startIndex: Int, endIndex: Int, isClosedRange: Bool = false) -> ExprSyntax {
    let array = (isClosedRange ? Array((startIndex..<endIndex)) : Array((startIndex...endIndex))).map {
        SyntaxFactory.makeArrayElement(
          expression: ExprSyntax(
            SyntaxFactory.makeIntegerLiteralExpr(
              digits: SyntaxFactory.makeIntegerLiteral("\($0)")
            )
          ),
            trailingComma: $0 == endIndex ? nil : (SyntaxFactory.makeCommaToken(trailingTrivia: .spaces(1))
          )
        )
    }
    
    return ExprSyntax(
      SyntaxFactory.makeArrayExpr(
        leftSquare: SyntaxFactory.makeLeftSquareBracketToken(),
        elements: SyntaxFactory.makeArrayElementList(array),
        rightSquare: SyntaxFactory.makeRightSquareBracketToken()
      )
    )
}
