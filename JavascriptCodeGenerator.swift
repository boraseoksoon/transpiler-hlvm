//
//  JavascriptCodeGenerator.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/09/13.
//

import Foundation
import SwiftSyntax

final class JavascriptCodeGenerator: SyntaxRewriter {
    private let language: Language = .javascript
    
    public override func visit(_ token: TokenSyntax) -> Syntax {
        let newToken = generateSyntax(from: token, to: language)
        return Syntax(newToken)
    }
    
    public override func visit(_ node: TypealiasDeclSyntax) -> DeclSyntax {
        // fatalError("TypealiasDeclSyntax : \(node) Uncaught SyntaxError: Unexpected identifier")
        return super.visit(node)
    }

    public override func visit(_ node: IfStmtSyntax) -> StmtSyntax {
        // implemented: testBoolean
        let newNode = makeIfStmt(node: node, language: .javascript)
        return super.visit(newNode)
    }

    // reference: testMaximumInteger
    public override func visit(_ node: IdentifierExprSyntax) -> ExprSyntax {
        print("IdentifierExprSyntax : \(node)")

        func transformType(identifier: TokenSyntax) -> TokenSyntax {
            let res: TokenSyntax!
            
            if identifier.text.contains("Int") {
                res = SyntaxFactory.makeIdentifier("Math.floor")
            } else if identifier.text.contains("Double") {
                res = SyntaxFactory.makeIdentifier("Number")
            } else {
                res = identifier
            }

            return res
                .withLeadingTrivia(node.identifier.leadingTrivia)
                .withTrailingTrivia(node.identifier.trailingTrivia)
        }
        
        let node = SyntaxFactory.makeIdentifierExpr(
            identifier: transformType(identifier: node.identifier),
            declNameArguments: node.declNameArguments
        )

        return super.visit(node)
    }

    // reference: testMaximumInteger
    public override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        print("MemberAccessExprSyntax : \(node)")
        print("node.name : \(node.name)")
        print("node.dot : \(node.dot)")
        print("node.base?.description : \(node.base?.description)")
        
        var mutNode = node

        switch typeOf(node.base?.description ?? "") {
            case .dictionary:
                fatalError("Implement me")
            case .array:
                fatalError("Implement me")
            case .unknown:
                func isInt(parentTokenText: String?) -> Bool {
                    switch parentTokenText {
                        case "UInt8", "UInt16", "UInt32", "UInt64", "Int8", "Int16", "Int32", "Int64" :
                            return true
                        default:
                            return true
                    }
                }
                
                let parentTokenText = node.parent?.firstToken?.text
                if isInt(parentTokenText: parentTokenText) {
                    switch node.name.text {
                        case "max":
                            mutNode = node
                                .withBase(ExprSyntax(SyntaxFactory.makeVariableExpr("Number")))
                                .withName(SyntaxFactory.makeIdentifier("MAX_SAFE_INTEGER"))
                                .withLeadingTrivia(node.leadingTrivia ?? .spaces(0))
                                .withTrailingTrivia(node.trailingTrivia ?? .spaces(0))
                            
                        case "min":
                            mutNode = node
                                .withBase(ExprSyntax(SyntaxFactory.makeVariableExpr("Number")))
                                .withName(SyntaxFactory.makeIdentifier("MIN_SAFE_INTEGER"))
                                .withLeadingTrivia(node.leadingTrivia ?? .spaces(0))
                                .withTrailingTrivia(node.trailingTrivia ?? .spaces(0))
                                
                        default:
                            break
                    }
                }
        }
        
        return super.visit(mutNode)
    }
    
    
    public override func visit(_ node: ReturnStmtSyntax) -> StmtSyntax {
        return super.visit(node)
    }
    
    public override func visit(_ node: StringSegmentSyntax) -> Syntax {
        return super.visit(node)
    }
    
//    public override func visit(_ node: PatternBindingSyntax) -> Syntax {
//        func eraseType() -> TypeAnnotationSyntax {
//            SyntaxFactory.makeTypeAnnotation(colon: SyntaxFactory.makeIdentifier(""),
//                                             type: SyntaxFactory.makeTypeIdentifier(""))
//        }
//        
//        let node = SyntaxFactory.makePatternBinding(pattern: node.pattern,
//                                                    typeAnnotation: eraseType(),
//                                                    initializer: node.initializer,
//                                                    accessor: node.accessor,
//                                                    trailingComma: node.trailingComma)
//
//        return super.visit(node)
//    }
    
    public override func visit(_ node: StringLiteralSegmentsSyntax) -> Syntax {
        print("StringLiteralSegments : \(node)")
        
        // TODO: SERIOUSLY Fragile code
        let res: [String] = node.tokens.map {
            if $0.text == "\\" {
                return "$"
            } else if $0.text == "(" {
                return "{"
            } else if $0.text == ")" {
                return "}"
            } else {
                return $0.text
            }
        }
        print("res : \(res)")
        
        let variable = Syntax(SyntaxFactory.makeIdentifier(res.joined()))
        let node = SyntaxFactory.makeStringLiteralSegments([variable])
        
        return super.visit(node)
    }
    
//    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
//        print("FunctionCallExprSyntax : \(node)")
//        print("node.calledExpression : \(node.calledExpression)")
//        var node = node
//
//        // dict.updateValue(100, forKey: "k1")
//        // dict["k1"] = 100
//
//        let calledExpressionSyntaxString = node.calledExpression.tokens
//            .map { $0.text }
//            .joined()
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        print("calledExpressionSyntaxString : \(calledExpressionSyntaxString)")
//        print("node.argumentList : \(node.argumentList)")
//
//
//        if (calledExpressionSyntaxString.hasPrefix("Int(") && calledExpressionSyntaxString.hasSuffix(")")) {
//
//            node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("Math.floor")),
//                                                      leftParen: node.leftParen,
//                                                      argumentList: node.argumentList,
//                                                      rightParen: node.rightParen,
//                                                      trailingClosure: nil,
//                                                      additionalTrailingClosures: nil)
//        }
//
//        return super.visit(node)
//    }

    
}

