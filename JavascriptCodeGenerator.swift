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
    
    public override func visit(_ node: ReturnStmtSyntax) -> StmtSyntax {
        return super.visit(node)
    }
    
    public override func visit(_ node: StringSegmentSyntax) -> Syntax {
        return super.visit(node)
    }
    
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
}

