//
//  CodeGenerator.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation
import SwiftSyntax

final class CodeGenerator: SyntaxRewriter {
    private let language: Language
    private let AST: SourceFileSyntax
    private let generator: SyntaxRewriter
    
    init(from AST: SourceFileSyntax, for language: Language) {
        self.language = language
        self.AST = AST
        
        switch language {
            case .python:
                self.generator = PythonCodeGenerator()
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

extension CodeGenerator {
    func generate() -> String {
        self.generator.visit(AST).description
    }
}

