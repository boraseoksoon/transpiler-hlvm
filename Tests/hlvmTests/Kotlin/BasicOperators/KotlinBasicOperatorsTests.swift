//
//  KotlinBasicOperatorsTests.swift
//  hlvmTests
//
//  Created by Seoksoon Jang on 2021/08/27.
//

import XCTest
import class Foundation.Bundle
import hlvm

final public class KotlinBasicOperatorsTests: XCTestCase {
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

// MARK: - 1. Assignment Operator [❌]
extension KotlinBasicOperatorsTests {
    func testAssignmentOperator() throws {
        let swiftSource = """
        let b = 10
        var a = 5
        a = b
        // a is now equal to 10

        let (x, y) = (1, 2)
        // x is equal to 1, and y is equal to 2

        if x == y {
            // This isn't valid, because x = y doesn't return a value.
        }
        """

        let kotlinSource = """
        val b = 10
        var a = 5
        a = b
        // a is now equal to 10

        val (x, y) = Pair(1, 2)
        // x is equal to 1, and y is equal to 2

        if (x == y) {
            // This isn't valid, because x = y doesn't return a value.
        }
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 99. TEST [❌]
extension KotlinBasicOperatorsTests {
    func testTemplate() throws {
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
