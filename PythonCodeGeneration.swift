//
//  Python.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/08.
//

import Foundation
import SwiftSyntax

//func generatePythonSyntax(from token: TokenSyntax) -> TokenSyntax {
////    print("token : \(token)")
////    print("token.tokenKind : \(token.tokenKind)")
////    print("token.tokens : \(token.tokens.map { $0.text })")
//    
//    switch token.tokenKind {
//        case .leftAngle:
//            token
//            // <
//            return token.withKind(token.tokenKind)
//        case .colon:
//            return token.withKind(token.tokenKind)
//        case .leftSquareBracket:
//            if token.nextToken?.nextToken?.tokenKind == .comma || token.nextToken?.nextToken?.tokenKind == .rightSquareBracket {
//                return token.withKind(token.tokenKind)
//            } else {
//                return token.withKind(.leftBrace)
//            }
//        case .rightSquareBracket:
//            if token.previousToken?.previousToken?.tokenKind == .comma || token.previousToken?.previousToken?.tokenKind == .leftSquareBracket {
//                return token.withKind(token.tokenKind)
//            } else {
//                return token.withKind(.rightBrace)
//            }
//        case .structKeyword:
//            return token.withKind(.classKeyword)
//        case .identifier(let identifierName):
//            return token.withKind(.identifier(identifierName))
//            
//        case .leftBrace:
//            return token.withKind(.colon)
//        case .rightBrace:
//            return token.withKind(.unknown(""))
//                .withoutTrivia()
//                .withLeadingTrivia(Trivia.newlines(1))
//        case .letKeyword:
//            return token.withKind(.unknown(""))
//                .withTrailingTrivia(Trivia.spaces(0))
//        case .varKeyword:
//            return token.withKind(.unknown(""))
//                .withTrailingTrivia(Trivia.spaces(0))
//        case .integerLiteral(let text):
//            let integerText = String(text.filter { ("0"..."9").contains($0) })
//            return token.withKind(.integerLiteral("\(Int(integerText)!)"))
//        case .eof:
//            // print("eof : \(token)")
//            return token.withKind(token.tokenKind)
//        default:
//             return token.withKind(token.tokenKind)
//            
////            let msg = """
////            no token text : \(token.text) token Kind : \(token.tokenKind)!
////            """
////
////            fatalError(msg)
//    }
//}
