//
//  CodeGenerator.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation
import SwiftSyntax

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
    
    public override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        // print("VariableDeclSyntax node : \(node)")
        return super.visit(node)
    }
    
    public override func visit(_ node: PatternBindingSyntax) -> Syntax {
        print("PatternBindingSyntax : \(node.initializer)")

        func eraseType(node: TypeAnnotationSyntax) -> TypeAnnotationSyntax {
            SyntaxFactory.makeTypeAnnotation(colon: SyntaxFactory.makeIdentifier("").withTrailingTrivia(.spaces(1)),
                                             type: SyntaxFactory.makeTypeIdentifier(""))
        }
        
        func makeEmptyArray(node: PatternBindingSyntax) -> PatternBindingSyntax {
            let array = SyntaxFactory.makeArrayElement(
                expression: ExprSyntax(SyntaxFactory.makeBlankArrayExpr()),
                trailingComma: nil)
            
            let leftSquare = SyntaxFactory.makeLeftSquareBracketToken()
            let rightSquare = SyntaxFactory.makeRightSquareBracketToken()
            
            let arr = SyntaxFactory.makeArrayExpr(leftSquare: leftSquare,
                                                  elements: SyntaxFactory.makeArrayElementList([array]),
                                                  rightSquare: rightSquare)
            let arrayList = arr.withLeadingTrivia(.spaces(1))
            let arrayExpression = ExprSyntax(arrayList)

            let initalizer = SyntaxFactory.makeInitializerClause(equal: SyntaxFactory.makeEqualToken(),
                                                                 value: arrayExpression)
            
            return SyntaxFactory.makePatternBinding(pattern: node.pattern,
                                                    typeAnnotation: eraseType(node:node.typeAnnotation!),
                                                    initializer: initalizer,
                                                    accessor: node.accessor,
                                                    trailingComma: node.trailingComma)
        }
        
        var node = node
        if node.initializer == nil {
            // var arr: [Int]
            //
            let node = makeEmptyArray(node:node)
            return Syntax(node)
            
            // return super.visit(node)
            // return super.visit(node)
        } else {
            // var arr: [Int] = []
//            print("node.typeAnnotation : \(node.typeAnnotation)")
//            print("node.pattern : \(node.pattern)")
//            print("node.accessor : \(node.accessor)")
            
            let typeAnnotation = node.typeAnnotation == nil ?
                node.typeAnnotation // SyntaxFactory.makeBlankTypeAnnotation()
                :
                eraseType(node:node.typeAnnotation!)
            
            let node = SyntaxFactory.makePatternBinding(pattern: node.pattern,
                                             typeAnnotation: typeAnnotation,
                                             initializer: node.initializer,
                                             accessor: node.accessor,
                                             trailingComma: node.trailingComma)
            
            // return Syntax(node)
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
        print("IdentifierExprSyntax node : \(node)")
        print("********")
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
        
        if syntaxString.contains("(arrayLiteral:") || syntaxString.contains("Set<String>")
        {
            print("(arrayLiteral: replace!: \(node.argumentList)")
            
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
            
            let argumentList = node.argumentList.map {
                $0
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
        } else if isDict {
            node = SyntaxFactory.makeFunctionCallExpr(calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("{}")),
                                                      leftParen: nil,
                                                      argumentList: SyntaxFactory.makeBlankTupleExprElementList(),
                                                      rightParen: nil,
                                                      trailingClosure: nil,
                                                      additionalTrailingClosures: nil)
        } else if (node.calledExpression.firstToken?.text ?? "").contains("Set") {
            print("true node.calledExpression : \(node.calledExpression)")
            
            
            let argumentList = node.argumentList.map {
                $0
                .withLabel($0.label?.withKind(.unknown("")))
                .withColon($0.colon?.withKind(.unknown(""))
                .withoutTrivia())
            }
            
            let list = SyntaxFactory.makeTupleExprElementList(argumentList)
            return super.visit(node.withArgumentList(list))
        }
        
        return super.visit(node)
    }
    
    public override func visit(_ node: CodeBlockSyntax) -> Syntax {
        print("CodeBlockSyntax node : \(node)")
        let leftBrace = SyntaxFactory.makeColonToken().withoutTrivia()
        let rightBrace = SyntaxFactory.makeUnknown("").withoutTrivia().withLeadingTrivia(Trivia.newlines(0))
        let node = SyntaxFactory.makeCodeBlock(leftBrace: leftBrace, statements: node.statements, rightBrace: rightBrace)
        
        return super.visit(node)
    }
    
    public override func visit(_ node: FunctionParameterSyntax) -> Syntax {
        print("FunctionParameterSyntax : \(node)")
        let colon = node.firstToken?.withKind(.unknown("")).withoutTrivia()
        let node = node.withColon(colon).withType(.none)
        
        return super.visit(node)
    }

    public override func visit(_ node: TupleExprElementListSyntax) -> Syntax {
        print("TupleExprElementListSyntax : \(node)")
        print("************")
        
        if case .identifier(let name) = node.parent?.firstToken?.tokenKind {
            if name == "print" {
                // node.first!
                guard let first = node.first else { return super.visit(node) }
                
                let isPlainPrint = node.tokens.filter {
                    $0.text == SyntaxFactory.makeIdentifier("\\").text
                }.isEmpty
                
                let isCommaPrint = !(node.tokens.filter {
                    return $0.text == ","
                }.isEmpty)

                if isCommaPrint {
                    return super.visit(node)
                } else {
                    let list = SyntaxFactory.makeTupleExprElementList([
                        SyntaxFactory.makeTupleExprElement(
                            label: isPlainPrint ? nil : SyntaxFactory.makeIdentifier("f"),
                            colon: nil,
                            expression: node.first!.expression,  // isPlainPrint ? node.first!.expression : expr,
                            trailingComma: nil// SyntaxFactory.makeCommaToken()
                        )
                    ])
                    
                    // return Syntax(list)
                    return super.visit(list)
                }
            }
        } else {
            return super.visit(node)
        }
        
        return super.visit(node)
    }
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
