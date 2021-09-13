//
//  JavascriptStringAndCharactersTests.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/29.
//

import XCTest
import class Foundation.Bundle

final public class JavascriptStringAndCharactersTests: XCTestCase {
    private let language: Language = .javascript
    
    func input(source: String) -> String {
        """
        \(language.rawValue) {
            \(source)
        }
        """
    }
    
    func isEqual(swiftSource: String, javascriptSource: String) throws {
        let code1 = transpile(input(source: swiftSource))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let code2 = javascriptSource
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(code1)
        print("**** divider *****")
        print(code2)
        
        XCTAssertEqual(code1, code2)
    }
}

// MARK: - 1. String Literals [❌]
extension JavascriptStringAndCharactersTests {
//    - Multiline String Literals  [❌]
    func testMultilineStringLiterals() throws {
        let swiftSource = """
        x
        """

        let javascriptSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
//    - Special Characters in String Literals [❌]
    func testSpecialCharactersInStringLiterals() throws {
        let swiftSource = """
        b
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
//    - Extended String Delimiters [❌]
    func testExtendedStringDelimiters() throws {
        let swiftSource = """
        b
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 99. TEST [❌]
extension JavascriptStringAndCharactersTests {
    func testTemplate() throws {
        let swiftSource = """
        b
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}
