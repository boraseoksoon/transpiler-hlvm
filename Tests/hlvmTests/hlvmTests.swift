//
//  hlvmTests.swift
//  hlvmTests
//
//  Created by Seoksoon Jang on 2021/08/19.
//

import XCTest
import class Foundation.Bundle
import hlvm

final public class hlvmTests: XCTestCase {
    private let language: Language = .kotlin
    
    func input(source: String) -> String {
        """
        \(language.rawValue) {
            \(source)
        }
        """
    }
    
    func isEqual(swiftSource: String, kotlinSource: String) throws {
        XCTAssertEqual(
            transpile(input(source: swiftSource),
                      to: Language.kotlin)
                .trimmingCharacters(in: .whitespaces),
            kotlinSource
                .trimmingCharacters(in: .whitespaces)
        )
    }
}

// MARK: - 1. Constants and Variables
extension hlvmTests {
//    - Declaring Constants and Variables [✅]
    func testConstantAndVariable() throws {
        let swiftSource = """
        let maximumNumberOfLoginAttempts = 10
        var currentLoginAttempt = 0
        """

        let kotlinSource = """
        val maximumNumberOfLoginAttempts = 10
        var currentLoginAttempt = 0
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
//    - Type Annotations [✅]
    func testTypeAnnotation() throws {
        let swiftSource = """
        var red, green, blue: Double
        """

        let kotlinSource = """
        var red, green, blue: Double
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
//    - Naming Constants and Variables [✅]
    
//    - Printing Constants and Variables [❌]
    func testPrint() throws {
        let swiftSource = """
        print(friendlyWelcome)
        print("The current value of friendlyWelcome is \\(friendlyWelcome)")
        """

        let kotlinSource = """
        print(friendlyWelcome)
        print("The current value of friendlyWelcome is ${friendlyWelcome}")
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}
