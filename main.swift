//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let swiftSource = """
python {
    for i in [0,1,2,3,4] {
        print("i : ", i)
    }
}
"""

let swiftSource2 = """
    struct Human {
        var height: Set<String> = ["0", "1"]
        var age: Int = 20
        var name: String? = nil
        var name2: String = ""
        var genderMap: [String:Any] = [:]
        var hash2: [Int: Int] = [Int: Int]()
        var hash3: [Int: Int]? = nil
        var arr: [Int]? = []
        var arr2: [Int] = []
    }

    let human = Human()
    print(human.age)

}
"""

let res = transpile(swiftSource4)
print(res)

//for i in [0,1,2,3,4] :
//    print("i : ", i)

func transpile(_ source: String, to language: Language? = nil) -> String {
    guard let language = language == nil ? recognizeLanguage(from: source) : language
        else { return source }

    // let trimmedSource = source.trimSource(for: language)
    let (_, indentedSource) = indent(source: source)
    let AST = try! SyntaxParser.parse(source: indentedSource)
    let generatedCode = generateCode(from: AST, for: language)
    
    return generatedCode
}

func generateCode(from AST: SourceFileSyntax, for language: Language) -> String {
    return CodeGenerator(for: language).visit(AST).description
    // Visitor(language: language).visit(AST).description
}
