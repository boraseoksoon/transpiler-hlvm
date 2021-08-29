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
        
    // MARK: - LifeCycle
    public override func visit(_ token: TokenSyntax) -> Syntax {
        // print("TokenSyntax : \(token)")
        return super.visit(token)
    }

    public override func visit(_ node: OptionalBindingConditionSyntax) -> Syntax {
        print("OptionalBindingConditionSyntax : \(node)")
        return super.visit(node)
    }
    
    public override func visit(_ node: ForcedValueExprSyntax) -> ExprSyntax {
        print("ForcedValueExprSyntax : \(node)")
        
        let node = node.withExclamationMark(SyntaxFactory.makeIdentifier("!!"))
        return super.visit(node)
    }

    public override func visit(_ node: TupleExprSyntax) -> ExprSyntax {
        print("TupleExprSyntax : \(node)")
        
        var mutNode = node
        
        let isInitializerClause = (
            recurScan(node: node.previousToken, forKeyword: "=", isBackward: true) &&
            (
                recurScan(node: node.previousToken, forKeyword: "var", isBackward: true) ||
                recurScan(node: node.previousToken, forKeyword: "let", isBackward: true)
            )
        )
        
//        let http200Status = (statusCode: 200, description: "OK")
//        print("The status code is \\(http200Status.statusCode)")
//        print("The status message is \\(http200Status.description)")
        // =>
//        val http200Status = mapOf("statusCode" to 200, "description" to "OK")
//        print("The status code is ${http200Status["statusCode"]}")
//        print("The status message is ${http200Status["description"]}")
        let tokens = node.elementList.tokens.map({ $0.text }).joined()
        if tokens.contains(":") && tokens.contains(",") {
            /// Example:
            /// let http200Status = (statusCode: 200, description: "OK")
            /// =>
            /// val http200Status = mapOf("statusCode" to 200, "description" to "OK")
            func transformTupleToKotlinMap(node: TupleExprSyntax) -> TupleExprSyntax {
                SyntaxFactory.makeTupleExpr(
                    leftParen: SyntaxFactory.makeIdentifier("mapOf("),
                    elementList: SyntaxFactory.makeTupleExprElementList(
                        node.elementList.map {
                            SyntaxFactory.makeTupleExprElement(
                                label: SyntaxFactory.makeIdentifier("\"\($0.label?.text ?? "")\""),
                                colon: SyntaxFactory.makeIdentifier(" to "),
                                expression: $0.expression,
                                trailingComma: $0.trailingComma
                            )
                        }
                    ),
                    rightParen: SyntaxFactory.makeIdentifier(")")
                )
            }

            if isInitializerClause {
                if let identifierName = node.previousToken?.previousToken?.text {
                    runtimeTypeTable[identifierName] = .dictionary
                    mutNode = transformTupleToKotlinMap(node: node)
                }
            }
            
            return super.visit(mutNode)
        } else {
            /// let (x, y) = (1, 2)
            /// =>
            /// val (x, y) = Pair(1, 2)
            
            print("node.tokens.map { $0.text }.joined(): \(node.tokens.map { $0.text }.joined())")
            print("node.previousToken?.text : \(node.previousToken?.text)")
            print("node.previousToken?.previousToken?.text : \(node.previousToken?.previousToken?.text)")
            print("node.previousToken?.previousToken?.previousToken?.text : \(node.previousToken?.previousToken?.previousToken?.text)")
            
            
            // let (x, y) = (1, 2)
            // let (x"," y")" = (1, 2)
            let rightParen = node.previousToken?.previousToken?.text
            let comma = node.previousToken?.previousToken?.previousToken?.previousToken?.text

            if rightParen == ")" && comma == "," {
                func transformTupleToKotlinPair(node: TupleExprSyntax) -> TupleExprSyntax {
                    SyntaxFactory.makeTupleExpr(
                        leftParen: SyntaxFactory.makeIdentifier("Pair("),
                        elementList: node.elementList,
                        rightParen: SyntaxFactory.makeIdentifier(")")
                    )
                }
                
                if isInitializerClause {
                    mutNode = transformTupleToKotlinPair(node: node)
                }

                return super.visit(mutNode)
            } else {
                let tokensString = node.tokens.map { $0.text }.joined()
                
                if tokensString.contains("?") {
                    return super.visit(node)
                } else {
                    /// Example:
                    /// let http404Error = (404, "Not Found")
                    /// =>
                    /// val http404Error = arrayOf(404, "Not Found")
                    func transformTupleToKotlinArray(node: TupleExprSyntax) -> TupleExprSyntax {
                        SyntaxFactory.makeTupleExpr(
                            leftParen: SyntaxFactory.makeIdentifier("arrayOf("),
                            elementList: node.elementList,
                            rightParen: SyntaxFactory.makeIdentifier(")")
                        )
                    }

                    if isInitializerClause {
                        if let identifierName = node.previousToken?.previousToken?.text {
                            runtimeTypeTable[identifierName] = .array
                            mutNode = transformTupleToKotlinArray(node: node)
                        }
                    }

                    return super.visit(mutNode)
                }
            }
        }
    }
    
    public override func visit(_ node: IfStmtSyntax) -> StmtSyntax {
        // implemented: testBoolean
        let left = SyntaxFactory.makeConditionElement(condition: Syntax(SyntaxFactory.makeIdentifier("(")),
                                                      trailingComma: nil)
        
        let right = SyntaxFactory.makeConditionElement(condition: Syntax(SyntaxFactory.makeIdentifier(")").withTrailingTrivia(.spaces(1))),
                                                       trailingComma: nil)

        let conditions = node.conditions.map {
            SyntaxFactory.makeConditionElement(
                condition: Syntax(SyntaxFactory.makeIdentifier($0.condition.description.trimmingCharacters(in: .whitespacesAndNewlines))),
                trailingComma: $0.description.trimmingCharacters(in: .whitespacesAndNewlines).hasSuffix(",")
                    ? SyntaxFactory.makeIdentifier(" && ") : $0.trailingComma)
        }

        let node = SyntaxFactory.makeIfStmt(
            labelName: node.labelName,
            labelColon: node.labelColon,
            ifKeyword: node.ifKeyword,
            conditions: SyntaxFactory.makeConditionElementList(conditions).prepending(left).appending(right),
            body: node.body,
            elseKeyword: node.elseKeyword,
            elseBody: node.elseBody
        )
        
        return super.visit(node)
    }
    
    public override func visit(_ node: SimpleTypeIdentifierSyntax) -> TypeSyntax {
        print("SimpleTypeIdentifierSyntax : \(node)")
        var node = node
        if  node.name.text == "UInt8" ||
            node.name.text == "UInt16" ||
            node.name.text == "UInt32" ||
            node.name.text == "UInt64"
        {
            // TODO: UInt -> Int Workaround
            node = node.withName(SyntaxFactory.makeIdentifier("Int"))
                .withLeadingTrivia(node.leadingTrivia ?? .spaces(0))
                .withTrailingTrivia(node.trailingTrivia ?? .spaces(0))
            
        } else if node.name.text == "Int8" ||
            node.name.text == "Int16" ||
            node.name.text == "Int32" ||
            node.name.text == "Int64"
        {
            node = node.withName(SyntaxFactory.makeIdentifier("Int"))
                .withLeadingTrivia(node.leadingTrivia ?? .spaces(0))
                .withTrailingTrivia(node.trailingTrivia ?? .spaces(0))
        }
        
        
        
        return super.visit(node)
    }

    public override func visit(_ node: FloatLiteralExprSyntax) -> ExprSyntax {
        print("FloatLiteralExprSyntax node.digits : \(node.floatingDigits)")
        if node.floatingDigits.text.hasPrefix("0xC.") {
            return super.visit(
                node.withFloatingDigits(
                    SyntaxFactory.makeFloatingLiteral(
                        String(Float(node.floatingDigits.text) ?? 0.0)
                    )
                )
            )
        }

        return super.visit(node)
    }
    
    public override func visit(_ node: IntegerLiteralExprSyntax) -> ExprSyntax {
        print("IntegerLiteralExprSyntax node.digits : \(node.digits)")
        if node.digits.text.hasPrefix("0o") {
            return super.visit(
                node.withDigits(
                    SyntaxFactory.makeIntegerLiteral(
                        String(Int(node.digits.text.replacingOccurrences(of: "0o", with: ""), radix: 0o10) ?? 0)
                    )
                )
            )
        }

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
                // TODO: real, just done for test now
                mutNode = node
                    .withDot(nil)
                    .withName(SyntaxFactory.makeIdentifier("[\"\(node.name)\"]"))
            case .array:
                if let tupleIndex = Int(node.name.text) {
                    mutNode = node
                        .withDot(nil)
                        .withName(SyntaxFactory.makeIdentifier("[\(tupleIndex)]"))
                } else {
                    print("typeof array let tupleIndex = Int(node.name.text) error")
                }
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
                            mutNode = node.withName(SyntaxFactory.makeIdentifier("MAX_VALUE"))
                        case "min":
                            mutNode = node.withName(SyntaxFactory.makeIdentifier("MIN_VALUE"))
                        default:
                            break
                    }
                }
        }
        return super.visit(mutNode)
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
        
        //val a = true
        //val b = 1000
        //val c = 0
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

        print("InitializerClauseSyntax node.previousToken?.text : \(node.previousToken?.text)")
        
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
        return super.visit(node)
    }
        
    public override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        print("VariableDeclSyntax : \(node)")
        var mutNode = node
        
        enum PatternBindingSyntaxType {
            case optional
        }

        func makePatternBindingSyntax
        (
            node: PatternBindingSyntax,
            type: PatternBindingSyntaxType
        )
        -> PatternBindingSyntax
        {
            var expression: ExprSyntax!
            
            switch type {
                case .optional:
                    let variable = SyntaxFactory.makeVariableExpr("null")
                        .withLeadingTrivia(node.leadingTrivia ?? .spaces(0))
                        .withTrailingTrivia(.spaces(1))
                    
                    expression = ExprSyntax(variable)
            }

            let equal = SyntaxFactory.makeEqualToken()
                .withLeadingTrivia(.spaces(1))
                .withTrailingTrivia(.spaces(1))

            let initalizer = SyntaxFactory.makeInitializerClause(
                equal: equal,
                value: expression
            )
            
            return SyntaxFactory.makePatternBinding(pattern: node.pattern,
                                                    typeAnnotation: node.typeAnnotation,
                                                    initializer: initalizer,
                                                    accessor: node.accessor,
                                                    trailingComma: node.trailingComma)
        }

        print("isOptionalWithoutNilAssigned!")
        
        print("containsEqual!")
        let containsEqual = !recurScan(node: node.parent?.firstToken, forKeyword: "=", isBackward: false)
        print("containsQuestion!")
        let containsQuestion = recurScan(node: node.parent?.firstToken, forKeyword: "?", isBackward: false)
        let isOptionalWithoutNilAssigned = (containsEqual && containsQuestion)

        if isOptionalWithoutNilAssigned {
            // var convertedNumber: Int?
            // =>
            // val convertedNumber: Int? = null
            
            let bindings = node.bindings
                .withTrailingTrivia(.spaces(0))
                .map { makePatternBindingSyntax(node:$0, type: .optional) }
            
            mutNode = node
                .withBindings(SyntaxFactory.makePatternBindingList(bindings))
        }
        
        return super.visit(mutNode)
    }
    
    public override func visit(_ node: ExpressionSegmentSyntax) -> Syntax {
        print("kotlin ExpressionSegmentSyntax : \(node)")
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
    
    public override func visit(_ node: StringSegmentSyntax) -> Syntax {
        print("StringSegmentSyntax : \(node)")
        return super.visit(node)
    }
    
    public override func visit(_ node: StringLiteralSegmentsSyntax) -> Syntax {
        print("StringLiteralSegments : \(node)")
        return super.visit(node)
    }
    
    public override func visit(_ node: TypeAnnotationSyntax) -> Syntax {
        print("TypeAnnotationSyntax : \(node)")

        return super.visit(node)
    }

    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        print("FunctionCallExprSyntax : \(node)")
        
//        print("functionName!! : \(functionName)")
//        print("node.leftParen : \(node.leftParen?.text)")
//        print("node.argumentList : \(node.argumentList)")
//        print("node.rightParen : \(node.rightParen?.text)")
//        print("node.trailingClosure : \(node.trailingClosure)")
//        print("node.additionalTrailingClosures : \(node.additionalTrailingClosures)")
        
        var mutNode = node
        
        let containsFun = (node.previousToken?.firstToken?.text.contains("fun") ?? false)
        guard !containsFun else { return super.visit(node) }

        let containsPrint = mutNode.calledExpression.description.contains("print")
        
        let syntaxString = mutNode.tokens
            .map ({ $0.text })
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let functionName = mutNode.calledExpression.tokens
            .map { $0.text }
            .joined()

        func makeAssertTrailingClosure(message: String) -> ClosureExprSyntax {
            let codeBlock = SyntaxFactory.makeCodeBlockItem(
                item: Syntax(
                    SyntaxFactory.makeVariableExpr(message)
                        .withLeadingTrivia(.spaces(1))
                        .withTrailingTrivia(.spaces(1))
                ),
                semicolon: nil,
                errorTokens: nil
            )
            
            let trailingClosure = SyntaxFactory.makeClosureExpr(
                leftBrace: SyntaxFactory.makeLeftBraceToken(),
                signature: nil,
                statements: SyntaxFactory.makeCodeBlockItemList([codeBlock]),
                rightBrace: SyntaxFactory.makeRightBraceToken()
            ).withLeadingTrivia(.spaces(1))
            
            return trailingClosure
        }
        
        if functionName == "assertionFailure" {
            // assertionFailure("A person's age can't be less than zero.")
            // =>
            // assert(false) { "A person's age can't be less than zero." }
            func makeAssertionFailure(node: FunctionCallExprSyntax, message: String) -> FunctionCallExprSyntax {
                SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("assert")),
                    leftParen: node.leftParen,
                    argumentList: (
                        SyntaxFactory.makeTupleExprElementList(
                            node.argumentList
                                .map {
                                    $0
                                    .withExpression(ExprSyntax(SyntaxFactory.makeVariableExpr("false")))
                                    .withTrailingComma(nil)
                                }
                        )
                    ),
                    rightParen: node.rightParen,
                    trailingClosure: makeAssertTrailingClosure(message: message),
                    additionalTrailingClosures: node.additionalTrailingClosures
                )
            }
            
            let assertMessage = String(node.argumentList
                                        .last?
                                        .tokens
                                        .compactMap { $0.text }
                                        .joined() ?? "")
            
            mutNode = makeAssertionFailure(node: node, message: assertMessage)
            
        } else if functionName == "assert" || functionName == "precondition" {
            /// assert(age >= 0, "A person's age can't be less than zero.")
            /// =>
            /// assert(age >= 0) { "A person's age can't be less than zero." }
            
            func makeAssert(node: FunctionCallExprSyntax, functionName: String, message: String) -> FunctionCallExprSyntax {
                SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr(functionName)),
                    leftParen: node.leftParen,
                    argumentList: (
                        SyntaxFactory.makeTupleExprElementList(
                            node.argumentList
                                .dropLast()
                                .map {
                                    $0
                                    .withExpression($0.expression)
                                    .withTrailingComma(nil)
                                }
                        )
                    ),
                    rightParen: node.rightParen,
                    trailingClosure: makeAssertTrailingClosure(message: message),
                    additionalTrailingClosures: node.additionalTrailingClosures
                )
            }
            
            // ex: assert(age >= 0, "A person's age can't be less than zero.")
            // assertMessage =>
            // "A person's age can't be less than zero."
            let assertMessage = String(node.argumentList
                                        .last?
                                        .tokens
                                        .compactMap { $0.text }
                                        .joined() ?? "")
            
            let containsAssertMessage = (assertMessage.hasPrefix("\"") && assertMessage.hasSuffix("\""))
            
            if containsAssertMessage {
                mutNode = makeAssert(node: node,
                                     functionName: (functionName != "assert" ? "require" : functionName),
                                     message: assertMessage)
            }

        } else if syntaxString.contains("(arrayLiteral:") {
            print("(arrayLiteral: replace!: \(mutNode.argumentList)")
            let left = SyntaxFactory.makeIdentifier("arrayOf(")
            let right = SyntaxFactory.makeIdentifier(")")

            let argumentList = mutNode.argumentList
                .map {
                    $0
                    .withExpression($0.expression)
                    .withLabel($0.label?.withKind(.unknown("")))
                    .withColon($0.colon?.withKind(.unknown("")).withoutTrivia())
                }
            
            let list = SyntaxFactory.makeTupleExprElementList(argumentList)
            
            mutNode = SyntaxFactory.makeFunctionCallExpr(
                calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                leftParen: left,
                argumentList: list,
                rightParen: right,
                trailingClosure: mutNode.trailingClosure,
                additionalTrailingClosures: mutNode.additionalTrailingClosures
            )
            
        } else if containsPrint {
            let colon = containsPrint ? nil : SyntaxFactory.makeIdentifier("=")
            let list = SyntaxFactory.makeTupleExprElementList(
                mutNode.argumentList.map {
                    SyntaxFactory.makeTupleExprElement(
                        label: $0.label,
                        colon: colon,
                        expression: $0.expression,
                        trailingComma: $0.trailingComma
                    )
                }
            )
            
            mutNode = SyntaxFactory.makeFunctionCallExpr(
                calledExpression: mutNode.calledExpression,
                leftParen: mutNode.leftParen,
                argumentList: list,
                rightParen: mutNode.rightParen,
                trailingClosure: mutNode.trailingClosure,
                additionalTrailingClosures: mutNode.additionalTrailingClosures
            )
        } else {
            let isArray = functionName.hasPrefix("[") && functionName.hasSuffix("]")

            
//            [Int]
//            emptyArray<Int>()
            if isArray {
                print("isArray!")
                
                let type = functionName
                    .replacingOccurrences(of: "[", with: "")
                    .replacingOccurrences(of: "]", with: "")
                
                let left = SyntaxFactory.makeIdentifier("emptyArray<\(type)")
                let right = SyntaxFactory.makeIdentifier(">()")

                mutNode = SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                    leftParen: left,
                    argumentList: mutNode.argumentList,
                    rightParen: right,
                    trailingClosure: mutNode.trailingClosure,
                    additionalTrailingClosures: mutNode.additionalTrailingClosures
                )
            }
            
            if
                functionName.contains("UInt8") ||
                functionName.contains("UInt16") ||
                functionName.contains("UInt32") ||
                functionName.contains("UInt64") ||
                functionName.contains("UInt")
            {
                mutNode = SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                    leftParen: nil,
                    argumentList: mutNode.argumentList,
                    rightParen: SyntaxFactory.makeIdentifier(".toUInt()"),
                    trailingClosure: mutNode.trailingClosure,
                    additionalTrailingClosures: mutNode.additionalTrailingClosures
                )
            } else if
                    functionName.contains("Int8") ||
                    functionName.contains("Int16") ||
                    functionName.contains("Int32") ||
                    functionName.contains("Int64") ||
                    functionName.contains("Int")
            {
                mutNode = SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                    leftParen: nil,
                    argumentList: mutNode.argumentList,
                    rightParen: SyntaxFactory.makeIdentifier(".toInt()"),
                    trailingClosure: mutNode.trailingClosure,
                    additionalTrailingClosures: mutNode.additionalTrailingClosures
                )
            } else if functionName.contains("Double") {
                mutNode = SyntaxFactory.makeFunctionCallExpr(
                    calledExpression: ExprSyntax(SyntaxFactory.makeVariableExpr("")),
                    leftParen: nil,
                    argumentList: mutNode.argumentList,
                    rightParen: SyntaxFactory.makeIdentifier(".toDouble()"),
                    trailingClosure: mutNode.trailingClosure,
                    additionalTrailingClosures: mutNode.additionalTrailingClosures
                )
            }
        }

        return super.visit(
            mutNode
                .withLeadingTrivia(node.leadingTrivia ?? .spaces(0))
                .withTrailingTrivia(node.trailingTrivia ?? .spaces(0))
        )
    }
    
}

func recurScan(node: TokenSyntax?,
               forKeyword keyword: String,
               isBackward: Bool) -> Bool {
    ((node?.text ?? "" == keyword) ? true :
        ((node?.nextToken?.leadingTrivia.contains {
            if case .newlines(_) = $0 { return true } else { return false }
        } ?? false) ? false : (
            (node == nil ? false : recurScan(
                node:(isBackward ? node?.previousToken : node?.nextToken),
                forKeyword:keyword,
                isBackward: isBackward)
            ))
        ))
}

enum RuntimeType {
    case dictionary
    case array
    case unknown
}

typealias IdentifierName = String
var runtimeTypeTable: [String : RuntimeType] = [:]

func typeOf(_ identifierName: String) -> RuntimeType {
    runtimeTypeTable[identifierName] ?? .unknown
}
