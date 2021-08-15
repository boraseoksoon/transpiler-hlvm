//
//  PythonCodeGenerator.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/15.
//

import Foundation
import SwiftSyntax

public class PythonCodeGenerator: SyntaxRewriter {
    private let language: Language = .python
    
    public override func visit(_ token: TokenSyntax) -> Syntax {
        // return Syntax(token.withKind(.stringLiteral("swift")))
        let newToken = generateSyntax(from: token, to: language)
        return Syntax(newToken)
    }
    
    public override func visit(_ node: DictionaryExprSyntax) -> ExprSyntax {
        print("DictionaryExprSyntax : \(node)")
        
        // [":"]
        let isEmptyDict = (
            node.content.tokens.map { $0.text }.count == 1
            &&
            node.content.tokens.map { $0.text }.contains(":")
        )
        
        let leftSquare = SyntaxFactory.makeUnknown("{")
        let rightSquare = SyntaxFactory.makeUnknown("}")
        
        let node = SyntaxFactory.makeDictionaryExpr(
            leftSquare: leftSquare,
            content: isEmptyDict ? Syntax(SyntaxFactory.makeUnknown("")) : node.content,
            rightSquare: rightSquare
        )
        
        return super.visit(node)
    }
    
    public override func visit(_ node: NilLiteralExprSyntax) -> ExprSyntax {
        print("NilLiteralExprSyntax node : \(node)")
        let node = SyntaxFactory.makeNilLiteralExpr(nilKeyword: SyntaxFactory.makeUnknown("None"))
        
        return super.visit(node)
    }

    public override func visit(_ node: MemberDeclBlockSyntax) -> Syntax {
        print("MemberDeclBlockSyntax 좌측 스페이스 추가 if needed: \(node)")
        return super.visit(node.withLeadingTrivia(.spaces(node.leadingTrivia?.count == 0 ? 1 : 0)))
    }
    
    public override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        print("StructDeclSyntax : \(node)")
        return super.visit(node)
    }

    public override func visit(_ node: GenericWhereClauseSyntax) -> Syntax {
        print("GenericWhereClauseSyntax : \(node)")
        let node =  SyntaxFactory.makeBlankGenericWhereClause()
        
//        SyntaxFactory.makeBlankGenericRequirement().tri
//
//        SyntaxFactory.makeGenericWhereClause(whereKeyword: <#T##TokenSyntax#>, requirementList: <#T##GenericRequirementListSyntax#>)
        
//        lenodet node = SyntaxFactory.makeWhereClause(whereKeyword:SyntaxFactory.makeIdentifier(""),
//                                      guardResult: ExprSyntax(SyntaxFactory.makeVariableExpr("fuck")))
        
        return super.visit(node)
    }
    
    public override func visit(_ node: GenericParameterClauseSyntax) -> Syntax {
        print("GenericParameterClauseSyntax : \(node)")
        
        let node = SyntaxFactory.makeBlankGenericParameterClause()
            // .withTrailingTrivia(.spaces(10))
            // .withLeadingTrivia(.spaces(10))
        
        return super.visit(node)
    }
    
    public override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        // print("VariableDeclSyntax node : \(node)")
        return super.visit(node)
    }
    
    public override func visit(_ node: PatternBindingSyntax) -> Syntax {
        print("PatternBindingSyntax : \(node.initializer)")

        func eraseType() -> TypeAnnotationSyntax {
            SyntaxFactory.makeTypeAnnotation(colon: SyntaxFactory.makeIdentifier("").withTrailingTrivia(.spaces(1)),
                                             type: SyntaxFactory.makeTypeIdentifier(""))
        }
        
        enum PatternBindingSyntaxType {
            case emptyArray
            case none
        }
        func makePatternBindingSyntax(node: PatternBindingSyntax, type: PatternBindingSyntaxType) -> PatternBindingSyntax {
            
            var expression: ExprSyntax!
            switch type {
                case .emptyArray:
                    let array = SyntaxFactory.makeArrayElement(
                        expression: ExprSyntax(SyntaxFactory.makeBlankArrayExpr()),
                        trailingComma: nil)

                    let leftSquare = SyntaxFactory.makeLeftSquareBracketToken()
                    let rightSquare = SyntaxFactory.makeRightSquareBracketToken()
                    let arr = SyntaxFactory.makeArrayExpr(leftSquare: leftSquare,
                                                          elements: SyntaxFactory.makeArrayElementList([array]),
                                                          rightSquare: rightSquare)

                    expression = ExprSyntax(arr.withLeadingTrivia(.spaces(1)))
                case .none:
                    expression = ExprSyntax(SyntaxFactory.makeVariableExpr("None").withLeadingTrivia(.spaces(1)))
                default:
                    fatalError("not supported PatternBindingSyntaxType")
            }

            let initalizer = SyntaxFactory.makeInitializerClause(equal: SyntaxFactory.makeEqualToken(),
                                                                 value: expression)
            
            return SyntaxFactory.makePatternBinding(pattern: node.pattern,
                                                    typeAnnotation: eraseType(),
                                                    initializer: initalizer,
                                                    accessor: node.accessor,
                                                    trailingComma: node.trailingComma)
        }
        
        var node = node
        
        if node.initializer == nil {
            print("got node man : \(node)")
            let node = makePatternBindingSyntax(node:node, type: .none)
            return super.visit(node)
        } else {
            let typeAnnotation = node.typeAnnotation == nil ? node.typeAnnotation : eraseType()
            let node = SyntaxFactory.makePatternBinding(pattern: node.pattern,
                                             typeAnnotation: typeAnnotation,
                                             initializer: node.initializer,
                                             accessor: node.accessor,
                                             trailingComma: node.trailingComma)
            return super.visit(node)
        }
        
        return super.visit(node)
    }
    
    public override func visit(_ node: TypeAnnotationSyntax) -> Syntax {
        return super.visit(node)
    }

    public override func visit(_ node: CodeBlockItemSyntax) -> Syntax {
        return super.visit(node)
    }

    public override func visit(_ node: ExprListSyntax) -> Syntax {
        // print("ExprListSyntax node : \(node)")
        return super.visit(node)
    }
    
    public override func visit(_ node: TupleExprSyntax) -> ExprSyntax {
        if node.elementList.tokens.contains(where: { $0.text == "..." }),
           let stratIndexString = node.elementList.first?.firstToken?.text,
           let stratIndex = Int(stratIndexString),
           let endIndexString = node.elementList.last?.lastToken?.text,
           let endIndex = Int(endIndexString)
        {
            return makeArray(startIndex:stratIndex, endIndex:endIndex)
        }

        return super.visit(node)
    }
    
    /// Visit a `ExpressionSegmentSyntax`.
    ///   - Parameter node: the node that is being visited
    ///   - Returns: the rewritten node
    public override func visit(_ node: ExpressionSegmentSyntax) -> Syntax {
        print("ExpressionSegmentSyntax : \(node)")
        let node = node
            .withBackslash(SyntaxFactory.makeUnknown(""))
            .withLeftParen(SyntaxFactory.makeUnknown("{"))
            .withRightParen(SyntaxFactory.makeUnknown("}"))
            
        return super.visit(node)
    }
    
    public override func visit(_ node: IdentifierExprSyntax) -> ExprSyntax {
        return super.visit(node)
    }

    public override func visit(_ node: StringSegmentSyntax) -> Syntax {
        return super.visit(node)
    }

    public override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        return super.visit(node)
        
//        print("node.description : \(node.description)")
//        let newString = node.description
//            .dropFirst()
//            .dropLast()
//            .replacingOccurrences(of: "\\(", with: "{")
//            .replacingOccurrences(of: ")", with: "}")
//
//        let newNode = SyntaxFactory.makeStringLiteralExpr(newString)
//
//        return super.visit(newNode)
    }
    
    public override func visit(_ node: SpecializeExprSyntax) -> ExprSyntax {
        print("SpecializeExprSyntax : \(node)")
        print("node.expression : \(node.expression)")
        
//        let expr = ExprSyntax(SyntaxFactory.makeBlankOptionalChainingExpr())
//        let generic = SyntaxFactory.makeBlankGenericArgumentClause()
//        let node = SyntaxFactory.makeSpecializeExpr(expression: expr, genericArgumentClause: generic)
        
        return super.visit(node
                            .withExpression(ExprSyntax(SyntaxFactory.makeVariableExpr("set")))
                            .withGenericArgumentClause(SyntaxFactory.makeBlankGenericArgumentClause())
        )
    }
    
    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        print("FunctionCallExprSyntax : \(node)")
        print("node.calledExpression : \(node.calledExpression)")
        var node = node
        
        // dict.updateValue(100, forKey: "k1")
        // dict["k1"] = 100
        
        let calledExpressionSyntaxString = node.calledExpression.tokens
            .map { $0.text }
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    
        print("calledExpressionSyntaxString : \(calledExpressionSyntaxString)")
        print("node.argumentList : \(node.argumentList)")
        
        let isDict = (
            node.calledExpression.firstToken?.text == "["
            &&
            node.calledExpression.lastToken?.text == "]"
            &&
            node.calledExpression.tokens.map { $0.text }.contains(":")
        )

        let syntaxString = node.tokens
            .map ({ $0.text })
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if syntaxString.contains("updateValue(")
            &&
            syntaxString.hasSuffix(")")
            &&
            syntaxString.components(separatedBy: ".").count == 2
        {
            print("got dict!")
            
            // dict.updateValue(100, forKey: "k1")
            // caller => dict
            
            // nocompactMapmentList.tokens
            // dict.updateValue(100, forKey: "k1")
            // keyValue
            // ["100", "\"k1\""]
            
            let caller = calledExpressionSyntaxString.components(separatedBy: ".")[0]
            let keyValue = node.argumentList.tokens
                .map { $0.text }
                .joined()
                .replacingOccurrences(of: ",", with: "")
                .components(separatedBy: "forKey:")
            
            print("divided : \(keyValue)")
            
            if keyValue.count == 2 {
                let value = keyValue[0]
                let key = keyValue[1]
                
                let expression = ExprSyntax(SyntaxFactory.makeVariableExpr("\(caller)[\(key)] = \(value)"))
                let elements = [SyntaxFactory.makeTupleExprElement(
                    label: nil,
                    colon: nil,
                    expression: expression,
                    trailingComma: nil
                )]
                
                let list = SyntaxFactory.makeTupleExprElementList(elements)
                node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                                                          leftParen: nil,
                                                          argumentList: list,
                                                          rightParen: nil,
                                                          trailingClosure: nil,
                                                          additionalTrailingClosures: nil)
                return super.visit(node.withLeadingTrivia(.newlines(1)))
                
            } else {
                return super.visit(node)
            }
            
        } else if syntaxString.contains("removeValue(") &&
                  syntaxString.hasSuffix(")") &&
                  syntaxString.components(separatedBy: ".").count == 2
        {
            print("got remove value!")
            
            let caller = calledExpressionSyntaxString.components(separatedBy: ".")[0]
            let keyValue = node.argumentList.tokens
                .map { $0.text }
                .joined()
                .replacingOccurrences(of: ",", with: "")
                .components(separatedBy: "forKey:")
            
            print("divided : \(keyValue)")

            if keyValue.count == 2 {
                // let value = keyValue[0]
                let key = keyValue[1]

                let expression = ExprSyntax(SyntaxFactory.makeVariableExpr("del[\(caller)[\(key)]]"))
                let elements = [SyntaxFactory.makeTupleExprElement(
                    label: nil,
                    colon: nil,
                    expression: expression,
                    trailingComma: nil
                )]
                
                let list = SyntaxFactory.makeTupleExprElementList(elements)
                node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                                                          leftParen: nil,
                                                          argumentList: list,
                                                          rightParen: nil,
                                                          trailingClosure: nil,
                                                          additionalTrailingClosures: nil)
                return super.visit(node.withLeadingTrivia(.newlines(1)))
                
            } else {
                return super.visit(node)
            }
            
        }
        
        if syntaxString.hasPrefix("[") && syntaxString.hasSuffix("]()") {
            print("got him")
            
            let expression = ExprSyntax(SyntaxFactory.makeVariableExpr("[]"))
            let elements = [SyntaxFactory.makeTupleExprElement(
                label: nil,
                colon: nil,
                expression: expression,
                trailingComma: nil
            )]
            
            let list = SyntaxFactory.makeTupleExprElementList(elements)
            node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                                                      leftParen: nil,
                                                      argumentList: list,
                                                      rightParen: nil,
                                                      trailingClosure: nil,
                                                      additionalTrailingClosures: nil)
            return super.visit(node)
            
        } else if syntaxString.contains("(arrayLiteral:") {
            print("(arrayLiteral: replace!: \(node.argumentList)")

            let argumentList = node.argumentList
                .map {
                    return $0
                    .withExpression($0.expression)
                    .withLabel($0.label?.withKind(.unknown("")))
                    .withColon($0.colon?.withKind(.unknown("")))
                }

             let list = SyntaxFactory.makeTupleExprElementList(argumentList)
            
            node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                                                      leftParen: SyntaxFactory.makeLeftBraceToken(),
                                                      argumentList: list,
                                                      rightParen: SyntaxFactory.makeRightBraceToken(),
                                                      trailingClosure: nil,
                                                      additionalTrailingClosures: nil)
            return super.visit(node)

//            node.argumentList.tokens.forEach {
//                print("node.argumentList : \($0)")
//            }
            
//            let expression = NSExpression(format: node.argumentList.tokens.map { $0.text }.joined() )
//            (expression.expressionValue(with: nil, context: nil) as! [Any]).forEach {
//                print("got you? : \($0)")
//            }

//            let expression = node.argumentList.tokens.map { $0.text }.joined()
//            print("expression : \(expression)")
            
            
            
            
            
            // var set3 = Set<String>(["0", "1"])
            
//            let argumentList = [SyntaxFactory.makeTupleExprElement(label: nil, colon: nil, expression: ExprSyntax(SyntaxFactory.makeVariableExpr("fuck")), trailingComma: nil)]
            
//            let argumentList2 = SyntaxFactory.makeTupleExprElementList([
//                SyntaxFactory.makeTupleExprElement(
//                    label: nil,
//                    colon: nil,
//                    expression: node.calledExpression,
//                    trailingComma: nil
//                )
//            ])
            
//            var iter = node.argumentList.makeIterator()
//            while iter.next() != nil {
//                print("iter : ", iter)
//            }
            
//            node.argumentList = node.argumentList.
//            node.argumentList = node.argumentList.removing(childAt: 0)
//
            //            let expression = ExprSyntax(SyntaxFactory.makeVariableExpr("hey"))
            //            let arrays = (0...10)
            //            let elements = arrays.enumerated().map { index, _ in
            //                SyntaxFactory.makeTupleExprElement(
            //                    label: nil,
            //                    colon: nil,
            //                    expression: expression,
            //                    trailingComma: index == arrays.count - 1 ? nil : SyntaxFactory.makeCommaToken()
            //                )
            //            }
//
//            let list = SyntaxFactory.makeTupleExprElementList(elements)
            
                //.filter { $0.firstToken?.text == "[" || $0.lastToken?.text == "]" }
            
//            node.argumentList
//                .forEach { print("$0.expression : \($0.expression)") }
            
        } else if isDict {
            node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("{}")),
                                                      leftParen: nil,
                                                      argumentList: SyntaxFactory.makeBlankTupleExprElementList(),
                                                      rightParen: nil,
                                                      trailingClosure: nil,
                                                      additionalTrailingClosures: nil)
            return super.visit(node)
            
        } else if (calledExpressionSyntaxString.hasPrefix("Set<") && calledExpressionSyntaxString.hasSuffix(">")) {
            // var set3 = Set<String>(["0", "1"])
            print("despite syntaxString : \(syntaxString)")
            
            if syntaxString.contains(",") {
                node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                                                          leftParen: nil,
                                                          argumentList: node.argumentList,
                                                          rightParen: nil,
                                                          trailingClosure: nil,
                                                          additionalTrailingClosures: nil)
                
                return super.visit(node)
            } else {
                let argumentList = node.argumentList.map {
                    $0
                    .withLabel($0.label?.withKind(.unknown("")))
                    .withColon($0.colon?.withKind(.unknown(""))
                    .withoutTrivia())
                }

                let list = SyntaxFactory.makeTupleExprElementList(argumentList)
                return super.visit(node.withArgumentList(list))
            }
        }
        
        return super.visit(node)
    }

    public override func visit(_ node: ReturnClauseSyntax) -> Syntax {
        print("ReturnClauseSyntax : \(node)")
        let node = SyntaxFactory.makeReturnClause(arrow: SyntaxFactory.makeIdentifier(""), returnType: SyntaxFactory.makeTypeIdentifier(""))
        return super.visit(node)
    }
    
    public override func visit(_ node: FunctionSignatureSyntax) -> Syntax {
        print("FunctionSignatureSyntax : \(node)")
        var node = node
        node.output = SyntaxFactory.makeBlankReturnClause()
        return super.visit(node)
    }
    
    public override func visit(_ node: ForcedValueExprSyntax) -> ExprSyntax {
        let node = node.withExclamationMark(SyntaxFactory.makeIdentifier(""))
        return super.visit(node)
    }
    
    public override func visit(_ node: RepeatWhileStmtSyntax) -> StmtSyntax {
        print("RepeatWhileStmtSyntax : \(node)")

        let conditions = SyntaxFactory.makeConditionElementList([SyntaxFactory.makeConditionElement(condition: Syntax(node.condition), trailingComma: nil)])
        
        
        let node = SyntaxFactory.makeWhileStmt(labelName: node.labelName,
                                               labelColon: nil,
                                               whileKeyword: node.whileKeyword,
                                               conditions: conditions,
                                               body: node.body)
            .withLeadingTrivia(.newlines(1))
        
        return super.visit(node)
    }

    public override func visit(_ node: CodeBlockSyntax) -> Syntax {
        print("CodeBlockSyntax node : \(node)")
        let leftBrace = SyntaxFactory.makeColonToken()
            .withoutTrivia()
        
        let rightBrace = SyntaxFactory.makeUnknown("")
            .withoutTrivia()
            .withLeadingTrivia(.newlines(1))
            // .withTrailingTrivia(.newlines(1))
        
        let node = SyntaxFactory.makeCodeBlock(leftBrace: leftBrace,
                                               statements: node.statements,
                                               rightBrace: rightBrace)
        
        return super.visit(node)
    }
    
    public override func visit(_ node: FunctionParameterSyntax) -> Syntax {
        print("FunctionParameterSyntax : \(node)")
        let colon = node.firstToken?.withKind(.unknown("")).withoutTrivia()
        let node = node.withColon(colon).withType(.none)
        
        return super.visit(node)
    }
    public override func visit(_ node: TupleExprElementSyntax) -> Syntax {
        print("TupleExprElementSyntax : \(node)")
        
        print("node.label : ", node.label?.text)
        
        let node = SyntaxFactory.makeTupleExprElement(
            label: SyntaxFactory.makeIdentifier(""),
            colon: nil,
            expression: node.expression,
            trailingComma: node.trailingComma
        )
        return super.visit(node)
    }
    
//    public override func visit(_ node: TupleExprElementSyntax) -> Syntax {
//        print("TupleExprElementSyntax : \(node)")
//        return super.visit(node)
//    }
        
    public override func visit(_ node: TupleExprElementListSyntax) -> Syntax {
        print("TupleExprElementListSyntax : \(node)")
        print("************")
        
//        if case .identifier(let name) = node.parent?.firstToken?.tokenKind {
//            if name == "print" {
//                // node.first!
//                guard let first = node.first else { return super.visit(node) }
//
//                let isPlainPrint = node.tokens.filter {
//                    $0.text == SyntaxFactory.makeIdentifier("\\").text
//                }.isEmpty
//
//                let isCommaPrint = !(node.tokens.filter {
//                    return $0.text == ","
//                }.isEmpty)
//
//                if isCommaPrint {
//                    return super.visit(node)
//                } else {
//                    let list = SyntaxFactory.makeTupleExprElementList([
//                        SyntaxFactory.makeTupleExprElement(
//                            label: isPlainPrint ? nil : SyntaxFactory.makeIdentifier("f"),
//                            colon: nil,
//                            expression: node.first!.expression,  // isPlainPrint ? node.first!.expression : expr,
//                            trailingComma: nil// SyntaxFactory.makeCommaToken()
//                        )
//                    ])
//
//                    // return Syntax(list)
//                    return super.visit(list)
//                }
//            }
//        }
        
//        let list = SyntaxFactory.makeTupleExprElementList([
//            SyntaxFactory.makeTupleExprElement(
//                label: isPlainPrint ? nil : SyntaxFactory.makeIdentifier("f"),
//                colon: nil,
//                expression: node.first!.expression,  // isPlainPrint ? node.first!.expression : expr,
//                trailingComma: nil// SyntaxFactory.makeCommaToken()
//            )
//        ])
//
//        // return Syntax(list)
//        return super.visit(list)
        
//        node.tokens.map { $0.text }.joined().components(separatedBy: ",")
//
//        let node = SyntaxFactory.makeTupleExprElement(
//            label: SyntaxFactory.makeIdentifier(""),
//            colon: nil,
//            expression: node.first!.expression,
//            trailingComma: nil
//        )
//
//        let list = SyntaxFactory.makeTupleExprElementList([node])
        
        
        return super.visit(node)
    }
}
