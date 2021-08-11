//
//  Visitor.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation
import SwiftSyntax

//let swiftSource4 = """
//python {
//    a:   Int, b: String
//}
//"""

let swiftSource4 = """
python {
    func test(a:   Int, b: String) {
        print("hello \\(b), I will give you \\(a) dollar")
    }

    test(a: 10000000, b: "JSS")
}
""".replacingOccurrences(of: "print(", with: "print(f")

//func test(a:   Int, b: String) {
//    print("hello \\(b), I will give you \\(a) dollar")
//}

//def test(a, b):
//  print("hello {}, I will give you {} dollar".format(b, a))
//
//test(10000000, "JSS")



//let swiftSource4 = """
//python {
//    var a: Human<Asian>
//}
//"""

public class CodeGenerator: SyntaxRewriter {
    private let language: Language
    
    init(for language: Language) {
        self.language = language
    }
    
    public override func visit(_ token: TokenSyntax) -> Syntax {
        // return Syntax(token.withKind(.stringLiteral("swift")))
        let newToken = generateSyntax(from: token, to: language)
        return Syntax(newToken)
    }

    public override func visit(_ node: CodeBlockItemSyntax) -> Syntax {
        return super.visit(node)
    }

    public override func visit(_ node: TupleExprElementListSyntax) -> Syntax {
        return super.visit(node)
    }
    
    /// Visit a `StringSegmentSyntax`.
    ///   - Parameter node: the node that is being visited
    ///   - Returns: the rewritten node
    public override func visit(_ node: StringSegmentSyntax) -> Syntax {
        // print("StringSegmentSyntax : \(node.description)")
        return super.visit(node)
    }
    
    /// Visit a `ExpressionSegmentSyntax`.
    ///   - Parameter node: the node that is being visited
    ///   - Returns: the rewritten node
    public override func visit(_ node: ExpressionSegmentSyntax) -> Syntax {
        // print("hello {}, I will give you {} dollar".format(b, a))
        
        //let backslash = node.withBackslash(node.backslash.withKind(.unknown("fuck")))
//        SyntaxFactory.makeExpressionSegment(backslash: backslash, delimiter: backslash, leftParen: backslash, expressions: backslash, rightParen: backslash)
        // SyntaxFactory.make
        
        print("ExpressionSegmentSyntax : \(node.description)")
        return super.visit(node)
    }
    
    /// Visit a `StringLiteralExprSyntax`.
    ///   - Parameter node: the node that is being visited
    ///   - Returns: the rewritten node
    public override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        // print("StringLiteralExprSyntax : \(node.tokens)")
        
        
    
//        "hello \(b), I will give you \(a) dollar"
//        => print(f'Sum of {a} and {b} is {c}')
        
        // let newStringLiteral = SyntaxFactory.makeStringLiteralExpr()
        
        let newString = node.description
            .dropFirst()
            .dropLast()
            .replacingOccurrences(of: "\\(", with: "{")
            .replacingOccurrences(of: ")", with: "}")
        
        let newNode = SyntaxFactory.makeStringLiteralExpr(newString)
        
        return super.visit(newNode)
    }
    
    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        // node.calledExpression.tokens.forEach { print($0.text) }
        
        let argumentList = node.argumentList.map {
            $0
            .withLabel($0.label?.withKind(.unknown("")))
            .withColon($0.colon?.withKind(.unknown(""))
            .withoutTrivia())
        }
        
        let list = SyntaxFactory.makeTupleExprElementList(argumentList)
        return super.visit(node.withArgumentList(list))
    }
    
    public override func visit(_ node: FunctionParameterSyntax) -> Syntax {
        let colon = node.firstToken?.withKind(.unknown("")).withoutTrivia()
        let node = node.withColon(colon).withType(.none)
        
        return super.visit(node)
    }
    
//    public override func visit(_ node: FunctionSignatureSyntax) -> Syntax {
//        print("FunctionSignatureSyntax node.signature : \(node.input)")
//        // print("node.tokens : \(node.tokens)")
//
//        return Syntax(node)
//    }

}

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
            return token.withKind(.unknown("def"))
        
        case .structKeyword:
            return token.withKind(.classKeyword)
        case .leftBrace:
            return token.withKind(.colon)
                .withoutTrivia()
        case .rightBrace:
            return token.withKind(.unknown(""))
                .withoutTrivia()
                .withLeadingTrivia(Trivia.newlines(1))
        case .letKeyword:
            return token.withKind(.unknown(""))
                .withTrailingTrivia(Trivia.spaces(0))
        case .varKeyword:
            return token.withKind(.unknown(""))
                .withTrailingTrivia(Trivia.spaces(0))
        default:
             return token.withKind(token.tokenKind)

//            let msg = """
//            no token text : \(token.text) token Kind : \(token.tokenKind)!
//            """
//
//            fatalError(msg)
    }
    
    
//    switch token.tokenKind {
//        case .funcKeyword:
//            return token.withKind(.unknown("def"))
//        case .leftAngle:
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
//            if case .colon = token.previousToken?.tokenKind {
//                return token.withKind(.unknown(""))
//                    .withoutTrivia()
//            }
//            return token.withKind(.identifier(identifierName))
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
//        case .leftParen:
//            return token.withKind(token.tokenKind)
//        case .rightParen:
//            return token.withKind(token.tokenKind)
//
//        case .comma:
//            // return token.withKind(.unknown(""))
//            return token.withKind(token.tokenKind)
//        case .stringQuote:
//            return token.withKind(token.tokenKind) // token.withKind(.unknown("{"))
//        case .stringSegment:
//            return token.withKind(token.tokenKind)
//        case .stringInterpolationAnchor:
//            return token.withKind(token.tokenKind)
//        case .backslash:
//            return token.withKind(token.tokenKind)
//        case .eof:
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
