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

// Kotlin

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
