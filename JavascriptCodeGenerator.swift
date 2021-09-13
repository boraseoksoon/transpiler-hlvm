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
}

