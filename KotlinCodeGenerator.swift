//
//  KotlinCodeGenerator.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/15.
//

import Foundation
import SwiftSyntax

final class KotlinCodeGenerator: SyntaxRewriter {
    private let language: Language = .kotlin

    public override func visit(_ node: ExpressionSegmentSyntax) -> Syntax {
        // print("kotlin ExpressionSegmentSyntax : \(node)")
        let node = node
            .withBackslash(SyntaxFactory.makeUnknown("$"))
            .withLeftParen(SyntaxFactory.makeUnknown("{"))
            .withRightParen(SyntaxFactory.makeUnknown("}"))
            
        return super.visit(node)
    }

    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        print("FunctionCallExprSyntax : \(node)")
        print("node.calledExpression : \(node.calledExpression)")
        print("node.argumentList : \(node.argumentList)")
        
        guard !(node.previousToken?.firstToken?.text.contains("fun") ?? true) else {
            return super.visit(node)
        }
        
        var node = node
        
//        if node.calledExpression.description != "print" {
//            node = SyntaxFactory.makeFunctionCallExpr(calledExpression: node.calledExpression,
//                                                      leftParen:node.leftParen,
//                                                      argumentList:node.argumentList,
//                                                      rightParen:node.rightParen,
//                                                      trailingClosure:node.trailingClosure,
//                                                      additionalTrailingClosures:node.additionalTrailingClosures)
//        }
        
        let colon = (node.calledExpression.description.contains("print")) ? nil : SyntaxFactory.makeIdentifier("=")
        let list = SyntaxFactory.makeTupleExprElementList(
            node.argumentList.map {
                SyntaxFactory.makeTupleExprElement(
                    label: $0.label,
                    colon: colon,
                    expression: $0.expression,
                    trailingComma: $0.trailingComma
                )
            }
        )
        
        node = SyntaxFactory.makeFunctionCallExpr(calledExpression: node.calledExpression,
                                                  leftParen: node.leftParen,
                                                  argumentList: list,
                                                  rightParen: node.rightParen,
                                                  trailingClosure: node.trailingClosure,
                                                  additionalTrailingClosures: node.additionalTrailingClosures)
        // return super.visit(node.withLeadingTrivia(.newlines(1)))
        return super.visit(node)
    }
    
}
