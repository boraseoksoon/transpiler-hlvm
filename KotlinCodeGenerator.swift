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
    
//    public override func visit(_ node: IfStmtSyntax) -> StmtSyntax {
//    }

    // reference: testMaximumInteger
    public override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        print("MemberAccessExprSyntax : \(node)")
        
        var node = node
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
                    node = node.withName(SyntaxFactory.makeIdentifier("MAX_VALUE"))
                case "min":
                    node = node.withName(SyntaxFactory.makeIdentifier("MIN_VALUE"))
                default:
                    break
            }
        }
        
        return super.visit(node)
    }
    
    // reference: testMaximumInteger
    public override func visit(_ node: IdentifierExprSyntax) -> ExprSyntax {
        print("IdentifierExprSyntax : \(node)")

        func transformType(identifier: TokenSyntax) -> TokenSyntax {
            let res: TokenSyntax!
            switch identifier.text {
                case "UInt8":
                    res = SyntaxFactory.makeIdentifier("UInt")
                case "UInt16":
                    res = SyntaxFactory.makeIdentifier("UInt")
                case "UInt32":
                    res = SyntaxFactory.makeIdentifier("UInt")
                case "UInt64":
                    res = SyntaxFactory.makeIdentifier("UInt")
                case "Int8":
                    res = SyntaxFactory.makeIdentifier("Int")
                case "Int16":
                    res = SyntaxFactory.makeIdentifier("Int")
                case "Int32":
                    res = SyntaxFactory.makeIdentifier("Int")
                case "Int64":
                    res = SyntaxFactory.makeIdentifier("Int")
                default:
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
    
    public override func visit(_ node: TernaryExprSyntax) -> ExprSyntax {
        print("TernaryExprSyntax : \(node)")
//        let a = true
//        let b = 1000
//        let c = 0
//
//        let d = a ? b : c
//        print("d is \\(d)")
  
        // =>
        
        //let a = true
        //let b = 1000
        //let c = 0
        //
        //let d = a ? b : c
        //val d =  if (a) b else c
        
        let node = SyntaxFactory.makeTernaryExpr(
            conditionExpression: ExprSyntax(
                SyntaxFactory
                    .makeVariableExpr("if (\(node.conditionExpression.withoutTrivia()))")
                    .withTrailingTrivia(.spaces(1))
            ),
            questionMark: SyntaxFactory.makeIdentifier(""),
            firstChoice: node.firstChoice,
            colonMark: SyntaxFactory
                .makeIdentifier("else")
                .withTrailingTrivia(.spaces(1)),
            secondChoice:node.secondChoice
        )
        
        return super.visit(node)
    }
    
    public override func visit(_ node: ExprListSyntax) -> Syntax {
        print("ExprListSyntax : ", node.tokens.map { $0.text })
                
        guard node.previousToken?.text ?? "" == SyntaxFactory.makeIfKeyword().text
            else { return super.visit(node) }
        
        //        var a = 10
        //        let b: Int = 1000
        //
        //        if a > b { => if (a > b) {
        //          print("Choose a")
        //        } else {
        //          print("Choose b")
        //        }
        
        let node = node
            .withoutTrivia()
            .prepending(ExprSyntax(SyntaxFactory.makeVariableExpr("(")))
            .appending(ExprSyntax(SyntaxFactory.makeVariableExpr(")")))
            .withTrailingTrivia(.spaces(1))
        
        print("ExprListSyntax : \(node)")
        return super.visit(node)
    }

    public override func visit(_ node: InitializerClauseSyntax) -> Syntax {
        print("InitializerClauseSyntax : \(node)")        
        var node = node
        
        let valueTokens = node.value.tokens
            .map { $0.text }
            .joined()
        let isArray = valueTokens.hasPrefix("[") && valueTokens.hasSuffix("]")
        
        if isArray {
            let arrayValues = node.value.tokens
                .filter { !($0.text == "[" || $0.text == "]") }
                .map { $0.text }
                .joined()
            let exprString = "arrayOf(" + arrayValues + ")"
            let expr = ExprSyntax(SyntaxFactory.makeVariableExpr(exprString))
            node = node.withValue(expr)
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
        
        let spaces = node.tokens
            .map { $0.text }
            .contains(SyntaxFactory.makeEqualToken().text) ? 1 : 0
        
        let left = SyntaxFactory.makeIdentifier("Array<")
        let right = SyntaxFactory
            .makeIdentifier(">")
            .withTrailingTrivia(.spaces(spaces))
        
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
        let right = SyntaxFactory
            .makeIdentifier(">")
            .withTrailingTrivia(.spaces(1))
        
        let node = SyntaxFactory.makeArrayType(
            leftSquareBracket: left,
            elementType: node.elementType,
            rightSquareBracket: right
        )
        
        return super.visit(node)
    }
    
    public override func visit(_ node: ForInStmtSyntax) -> StmtSyntax {
        print("ForInStmtSyntax : \(node)")
//
//        print("node.labelName : \(node.labelName?.text)")
//        print("node.labelColon : \(node.labelColon?.text)")
//        print("node.forKeyword : \(node.forKeyword.text)")
//        print("node.caseKeyword : \(node.caseKeyword?.text)")
//        print("node.pattern : \(node.pattern.tokens.map { $0.text })")
//        print("node.typeAnnotation : \(node.typeAnnotation)")
//        print("node.inKeyword : \(node.inKeyword)")
//        print("node.sequenceExpr : \(node.sequenceExpr)")
//        print("node.whereClause : \(node.whereClause)")
//        print("node.body : \(node.body)")

        let expr = "\(node.sequenceExpr.description.trimmingCharacters(in: .whitespacesAndNewlines)))"
        
        let forKeyword = SyntaxFactory
            .makeIdentifier("for (")
            .withLeadingTrivia(node.leadingTrivia ?? .newlines(0))
        
        let sequenceExpr = ExprSyntax(
            SyntaxFactory
                .makeVariableExpr(expr)
                .withTrailingTrivia(.spaces(1))
        )

        let node = SyntaxFactory.makeForInStmt(
            labelName: node.labelName,
            labelColon: node.labelColon,
            forKeyword: forKeyword,
            caseKeyword: node.caseKeyword,
            pattern: node.pattern,
            typeAnnotation: node.typeAnnotation,
            inKeyword: node.inKeyword,
            sequenceExpr: sequenceExpr,
            whereClause: node.whereClause,
            body:node.body
        )

        return super.visit(node)
    }
    
    public override func visit(_ node: TypeAnnotationSyntax) -> Syntax {
        print("TypeAnnotationSyntax : \(node)")

        return super.visit(node)
    }

    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        print("FunctionCallExprSyntax : \(node)")
        
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
            
//            print("calledExpressionTokenJoined : \(calledExpressionTokenJoined)")
//            print("node.leftParen : \(node.leftParen?.text)")
//            print("node.argumentList : \(node.argumentList)")
//            print("node.rightParen : \(node.rightParen?.text)")
//            print("node.trailingClosure : \(node.trailingClosure)")
//            print("node.additionalTrailingClosures : \(node.additionalTrailingClosures)")
            
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
