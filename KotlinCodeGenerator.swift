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

    public override func visit(_ token: TokenSyntax) -> Syntax {
        // print("TokenSyntax : \(token)")
        return super.visit(token)
    }
    
    public override func visit(_ node: CodeBlockItemSyntax) -> Syntax {
        print("CodeBlockItemSyntax : \(node)")
        return super.visit(node)
    }

    public override func visit(_ node: InitializerClauseSyntax) -> Syntax {
        print("InitializerClauseSyntax : \(node)")        
        var node = node
        
        let valueTokens = node.value.tokens.map { $0.text }.joined()
        let isArray = valueTokens.hasPrefix("[") && valueTokens.hasSuffix("]")
        
        if isArray {
            let arrayValues = node.value.tokens.filter { !($0.text == "[" || $0.text == "]") }.map { $0.text }.joined()
            node = node.withValue(ExprSyntax(SyntaxFactory.makeVariableExpr("arrayOf(" + arrayValues + ")")))
        }
        
        return super.visit(node)
    }
        
    public override func visit(_ node: PatternBindingSyntax) -> Syntax {
        print("PatternBindingSyntax : \(node)")
        return super.visit(node)
    }
        
    public override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        print("VariableDeclSyntax node : \(node)")
        print("node.bindings : \(node.bindings)")

//        let node = SyntaxFactory.makeVariableDecl(
//            attributes: node.attributes,
//            modifiers: node.modifiers,
//            letOrVarKeyword: node.letOrVarKeyword,
//            bindings: node.bindings
//        )
        
        return super.visit(node)
    }
    
    public override func visit(_ node: ExpressionSegmentSyntax) -> Syntax {
        // print("kotlin ExpressionSegmentSyntax : \(node)")
        let node = node
            .withBackslash(SyntaxFactory.makeUnknown("$"))
            .withLeftParen(SyntaxFactory.makeUnknown("{"))
            .withRightParen(SyntaxFactory.makeUnknown("}"))
            
        return super.visit(node)
    }
    
    public override func visit(_ node: ArrayExprSyntax) -> ExprSyntax {
        print("ArrayExprSyntax : \(node)")
        
        let spaces = node.tokens.map { $0.text }.contains(SyntaxFactory.makeEqualToken().text) ? 1 : 0
        let left = SyntaxFactory.makeIdentifier("Array<")
        let right = SyntaxFactory.makeIdentifier(">").withTrailingTrivia(.spaces(spaces))
        
        let node = SyntaxFactory.makeArrayExpr(
            leftSquare: left,
            elements: node.elements,
            rightSquare: right
        )

        return super.visit(node)
    }
    
    public override func visit(_ node: ArrayTypeSyntax) -> TypeSyntax {
        print("ArrayTypeSyntax : \(node)")
        
        let left = SyntaxFactory.makeIdentifier("Array<")
        let right = SyntaxFactory.makeIdentifier(">").withTrailingTrivia(.spaces(1))
        
        let node = SyntaxFactory.makeArrayType(
            leftSquareBracket: left,
            elementType: node.elementType,
            rightSquareBracket: right
        )
        
        return super.visit(node)
    }
    
    public override func visit(_ node: TypeAnnotationSyntax) -> Syntax {
        print("TypeAnnotationSyntax : \(node)")

        return super.visit(node)
    }

    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        print("FunctionCallExprSyntax : \(node)")
        
        print("node.argumentList : \(node.argumentList)")
        print("node.calledExpression : \(node.calledExpression)")
        print("go : \(node.calledExpression.tokens.map { $0.text })")
        
        guard !(node.previousToken?.firstToken?.text.contains("fun") ?? true) else {
            return super.visit(node)
        }
        
        var node = node
        
        let isPrint = node.calledExpression.description.contains("print")
        
        let syntaxString = node.tokens
            .map ({ $0.text })
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let calledExpressionTokenJoined = node.calledExpression.tokens
            .map { $0.text }
            .joined()

        if syntaxString.contains("(arrayLiteral:") {
            print("(arrayLiteral: replace!: \(node.argumentList)")
            let left = SyntaxFactory.makeIdentifier("arrayOf(")
            let right = SyntaxFactory.makeIdentifier(")")

            let argumentList = node.argumentList
                .map {
                    $0
                    .withExpression($0.expression)
                    .withLabel($0.label?.withKind(.unknown("")))
                    .withColon($0.colon?.withKind(.unknown("")).withoutTrivia())
                }
            
            let list = SyntaxFactory.makeTupleExprElementList(argumentList)
            
            node = SyntaxFactory.makeFunctionCallExpr(
                calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                leftParen: left,
                argumentList: list,
                rightParen: right,
                trailingClosure: node.trailingClosure,
                additionalTrailingClosures: node.additionalTrailingClosures
            )
            
        } else if isPrint {
            let colon = isPrint ? nil : SyntaxFactory.makeIdentifier("=")
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
            
            node = SyntaxFactory.makeFunctionCallExpr(
                calledExpression: node.calledExpression,
                leftParen: node.leftParen,
                argumentList: list,
                rightParen: node.rightParen,
                trailingClosure: node.trailingClosure,
                additionalTrailingClosures: node.additionalTrailingClosures
            )
        } else {
            let isArray = calledExpressionTokenJoined.hasPrefix("[") && calledExpressionTokenJoined.hasSuffix("]")
            
            print("calledExpressionTokenJoined : \(calledExpressionTokenJoined)")
            print("node.leftParen : \(node.leftParen?.text)")
            print("node.argumentList : \(node.argumentList)")
            print("node.rightParen : \(node.rightParen?.text)")
            print("node.trailingClosure : \(node.trailingClosure)")
            print("node.additionalTrailingClosures : \(node.additionalTrailingClosures)")
            
//            [Int]
//            emptyArray<Int>()
            if isArray {
                print("isArray!")
                
                let type = calledExpressionTokenJoined
                    .replacingOccurrences(of: "[", with: "")
                    .replacingOccurrences(of: "]", with: "")
                
                let left = SyntaxFactory.makeIdentifier("emptyArray<\(type)")
                let right = SyntaxFactory.makeIdentifier(">()")

                node = SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                    leftParen: left,
                    argumentList: node.argumentList,
                    rightParen: right,
                    trailingClosure: node.trailingClosure,
                    additionalTrailingClosures: node.additionalTrailingClosures
                )
            }
        }

        return super.visit(node)
    }
    
}
