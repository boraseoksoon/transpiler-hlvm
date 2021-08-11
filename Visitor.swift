//
//  Visitor.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation
import SwiftSyntax

let swiftSource4 = """
python {
    func test(a: Int) {
        print("hello test with : \\(a)!")
    }
}
"""

public class CodeGenerator: SyntaxRewriter {
    private let language: Language
    
    init(for language: Language) {
        self.language = language
    }
    
    public override func visit(_ token: TokenSyntax) -> Syntax {
        let newToken = generateSyntax(from: token, to: language)
        return Syntax(newToken)
        
        // return Syntax(token.withKind(.stringLiteral("hey")))
    }
    
    func generateSyntax(from token: TokenSyntax, to language: Language) -> TokenSyntax {
        switch language {
            case .python:
                return generatePythonSyntax(from: token)
            case .kotlin:
                return generateKotlinSyntax(from: token)
            default:
                fatalError("\(language) is not implemented for code generation")
        }
    }
}

func generateKotlinSyntax(from token: TokenSyntax) -> TokenSyntax {
    token.withKind(.stringLiteral("kotlin"))
}

func generatePythonSyntax(from token: TokenSyntax) -> TokenSyntax {
    token.withKind(.stringLiteral("python"))
    
//    print("token : \(token)")
//    print("token.tokenKind : \(token.tokenKind)")
//    print("token.tokens : \(token.tokens.map { $0.text })")
    
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
}



//class Visitor: SyntaxRewriter {
//    private let language: Language
//
//    init(language: Language) {
//        self.language = language
//    }
//
//    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
////        node.tokens.forEach {
////            print("FunctionDeclSyntax $0.syntaxNodeType : \($0.tokenKind)")
////            print("FunctionDeclSyntax node.description : \($0.description)")
////        }
//
//        print("node.funcKeyword : \(node.funcKeyword)")
//        print("node.bod : \(node.body)")
//
//        return DeclSyntax(node)
//    }
//
////    override func visit(_ node: FunctionParameterSyntax) -> Syntax {
////        node.tokens.forEach {
////            print("FunctionParameterSyntax node.description : \($0.description)")
////        }
////        return Syntax(node)
////    }
//
////    override func visit(_ node: FunctionSignatureSyntax) -> Syntax {
////        node.tokens.forEach {
////            print("FunctionSignatureSyntax node.description : \($0.description)")
////        }
////        return Syntax(node)
////    }
//
//    override func visit(_ token: TokenSyntax) -> Syntax {
//        // print("token : token\(token.tokenKind)")
//
//
//        let newToken = generateSyntax(from: token, to: language)
//        return Syntax(newToken)
//    }
//}

// MARK: - Code Generation

//extension Visitor {
//    func generateSyntax(from token: TokenSyntax, to language: Language) -> TokenSyntax {
//        switch language {
//            case .python:
//                return generatePythonSyntax(from: token)
//            default:
//                fatalError("\(language) is not implemented for code generation")
//        }
//    }
//}
