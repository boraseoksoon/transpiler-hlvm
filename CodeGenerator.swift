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
    private let AST: SourceFileSyntax
    
    init(from AST: SourceFileSyntax, for language: Language) {
        self.language = language
        self.AST = AST
    }
    
    func generate() -> String {
        switch language {
            case .python:
                return PythonCodeGenerator().visit(AST).description
            case .clojure:
                fatalError("Unsupported language to transpile!")
            case .javascript:
                fatalError("Unsupported language to transpile!")
            case .scala:
                fatalError("Unsupported language to transpile!")
            case .swift:
                fatalError("Unsupported language to transpile!")
            case .unknown:
                fatalError("Unsupported language to transpile!")
            default:
                fatalError("Unsupported language to transpile!")
        }
    }
}
