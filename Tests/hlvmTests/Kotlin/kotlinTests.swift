//
//  hlvmTests.swift
//  hlvmTests
//
//  Created by Seoksoon Jang on 2021/08/19.
//

import XCTest
import class Foundation.Bundle
import hlvm

final public class kotlinTests: XCTestCase {
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
extension kotlinTests {
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
    func testNamingConstantsAndVariables() throws {
        let swiftSource = """
        let π = 3.14159
        let 你好 = "你好世界"
        let 🐶🐮 = "dogcow"
        """

        let kotlinSource = """
        val π = 3.14159
        val 你好 = "你好世界"
        val 🐶🐮 = "dogcow"
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
//    - Printing Constants and Variables [✅]
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

// MARK: - 2. Comments
extension kotlinTests {
    // - Single-line comments [✅]
    func testSinglelineComments() throws {
        let swiftSource = """
        // This is a comment.
        """

        let kotlinSource = """
        // This is a comment.
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Multiline comments [✅]
    func testMultilineComments() throws {
        let swiftSource = """
        /* This is also a comment
        but is written over multiple lines. */
        /**
         * You can edit, run, and share this code.
         * play.kotlinlang.org
         */
        """

        let kotlinSource = """
        /* This is also a comment
        but is written over multiple lines. */
        /**
         * You can edit, run, and share this code.
         * play.kotlinlang.org
         */
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Nested multiline comments [❌]
    func testNestedMultilineComments() throws {
        let swiftSource = """
        /* This is the start of the first multiline comment.
         /* This is the second, nested multiline comment. */
        This is the end of the first multiline comment. */
        """

        let kotlinSource = """
        /* This is the start of the first multiline comment.
         /* This is the second, nested multiline comment. */
        This is the end of the first multiline comment. */
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 3. Semicolons
extension kotlinTests {
    // - Optional semicolons [✅]
    func testOptionalSemicolons() throws {
        let swiftSource = """
        let cat = "🐱"; print(cat)
        """

        let kotlinSource = """
        val cat = "🐱"; print(cat)
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 4. Integers
extension kotlinTests {
    // Integer Bounds [❌]
    func testMaximumInteger() throws {
        let swiftSource = """
        let minValue = UInt8.min  // minValue is equal to 0, and is of type UInt8
        let maxValue = UInt8.max  // maxValue is equal to 255, and is of type UInt8
        """

        let kotlinSource = """
        
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // Int [❌]
    func testInt() throws {
        let swiftSource = """
        """

        let kotlinSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // UInt [❌]
    func testUInt() throws {
        let swiftSource = """
        """

        let kotlinSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// func + print
//func double(x: Int, y: Int) -> Int {
//    return y * x
//}
//
//let x = 20
//let y = 30
//let result = double(x:x, y:y)
//print("\\(x) * \\(y) : \\(result)")

// array + for

//let array: [Int] = [Int](arrayLiteral: 1,2,3)
//let array2: [String] = [String](arrayLiteral: "a", "yo")
//let array3 = [String](arrayLiteral: "a", "yo")
//let array4 = [1,2,3]
//let array5: [Int] = []
//let array6 = [String]()
//let array7: [Int] = [1,2,3]
//let array9: [String] = ["a", "man"]
//
//print("\(array)\(array2)\(array3)\(array4)\(array5)\(array6)\(array7)\(array9)")

// val array = arrayOf(1,2,3)

//let array: [Int] = [Int](arrayLiteral: 1,2,3)
//for element in array {
//    print(element)
//}

//        let a = true
//        let b = 1000
//        let c = 0
//
//        let d = a ? b : c
//        print("d is \\(d)")
  
        // =>
        
        //let a = true
        //let b = 1000
        //let c = 0
        //
        //let d = a ? b : c
        //val d =  if (a) b else c
