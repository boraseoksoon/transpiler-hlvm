//
//  CodeGenerator.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation
import SwiftSyntax

final class CodeGenerator: SyntaxRewriter {
    private let destinationLanguage: Language
    
    private let AST: SourceFileSyntax
    private let generator: SyntaxRewriter
    
    init(from AST: SourceFileSyntax, to destinationLanguage: Language) {
        self.destinationLanguage = destinationLanguage
        self.AST = AST
        
        switch destinationLanguage {
            case .kotlin:
                generator = KotlinCodeGenerator()
            case .python:
                generator = PythonCodeGenerator()
            case .clojure:
                fatalError("Unsupported language to transpile!")
            case .javascript:
                fatalError("Unsupported language to transpile!")
            case .scala:
                fatalError("Unsupported language to transpile!")
            case .swift:
                // fatalError("destination Swift is unsupported language in CodeGenerator!")
                generator = KotlinCodeGenerator()
            case .unknown:
                fatalError("Unsupported language to transpile!")
            default:
                fatalError("Unsupported language to transpile!")
        }
        
    }
}

extension CodeGenerator {
    func generate() -> String {
        generator.visit(AST).description
    }
}

