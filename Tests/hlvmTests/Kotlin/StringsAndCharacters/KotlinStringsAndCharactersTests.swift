//
//  KotlinStringsAndCharactersTests.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/29.
//

import XCTest
import class Foundation.Bundle
import hlvm

final public class KotlinStringAndCharactersTests: XCTestCase {
    private let language: Language = .kotlin
    
    func input(source: String) -> String {
        """
        \(language.rawValue) {
            \(source)
        }
        """
    }
    
    func isEqual(swiftSource: String, kotlinSource: String) throws {
        let code1 = transpile(input(source: swiftSource), to: language)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let code2 = kotlinSource
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(code1)
        print("**** divider *****")
        print(code2)
        
        XCTAssertEqual(code1, code2)
    }
}

// MARK: - 99. TEST [❌]
extension KotlinStringAndCharactersTests {
    func testTemplate() throws {
        let swiftSource = """
        b
        """

        let kotlinSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}
