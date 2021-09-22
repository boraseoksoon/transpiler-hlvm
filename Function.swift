//
//  Function.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/08.
//
import SwiftSyntax

public func makeIfStmt(node: IfStmtSyntax, language: Language) -> IfStmtSyntax {
    switch language {
        case .kotlin, .javascript:
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
            
            return node
        default:
            return node
    }
}

func eraseType() -> TypeAnnotationSyntax {
    SyntaxFactory.makeTypeAnnotation(colon: SyntaxFactory.makeIdentifier("").withTrailingTrivia(.spaces(1)),
                                     type: SyntaxFactory.makeTypeIdentifier(""))
}
