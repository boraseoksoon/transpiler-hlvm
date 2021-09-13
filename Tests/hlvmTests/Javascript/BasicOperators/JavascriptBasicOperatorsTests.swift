//
//  KotlinBasicOperatorsTests.swift
//  hlvmTests
//
//  Created by Seoksoon Jang on 2021/08/27.
//

import XCTest
import class Foundation.Bundle
import hlvm

final public class JavascriptBasicOperatorsTests: XCTestCase {
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 2. Arithmetic Operators [❌]
extension KotlinBasicOperatorsTests {
    // - Addition (+)  [❌]
    func testAddition() throws {
        let swiftSource = """
        1 + 2       // equals 3
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // - Subtraction (-) [❌]
    func testSubtraction() throws {
        let swiftSource = """
        5 - 3       // equals 2
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    // - Multiplication (*) [❌]
    func testMultiplication() throws {
        let swiftSource = """
        2 * 3       // equals 6
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    // - Division (/) [❌]
    func testDivision() throws {
        let swiftSource = """
        10.0 / 2.5  // equals 4.0
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    // - Remainder Operator [❌]
    func testRemainderOperator() throws {
        let swiftSource = """
        9 % 4
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    // - Unary Minus Operator [❌]
    func testUnaryMinusOperator() throws {
        let swiftSource = """
        let three = 3
        let minusThree = -three       // minusThree equals -3
        let plusThree = -minusThree   // plusThree equals 3, or "minus minus three"
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    // - Unary Plus Operator [❌]
    func testUnaryPlusOperator() throws {
        let swiftSource = """
        let minusSix = -6
        let alsoMinusSix = +minusSix  // alsoMinusSix equals -6
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 3. Compound Assignment Operators [❌]
extension KotlinBasicOperatorsTests {
    func testCompoundAssignmentOperators() throws {
        let swiftSource = """
        var a = 1
        a += 2
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 4. Comparison Operators [❌]
extension KotlinBasicOperatorsTests {
    func testComparisonOperators() throws {
        let swiftSource = """
        1 == 1   // true because 1 is equal to 1
        2 != 1   // true because 2 isn't equal to 1
        2 > 1    // true because 2 is greater than 1
        1 < 2    // true because 1 is less than 2
        1 >= 1   // true because 1 is greater than or equal to 1
        2 <= 1   // false because 2 isn't less than or equal to 1
        
        let name = "world"
        if name == "world" {
            print("hello, world")
        } else {
            print("I'm sorry \\(name), but I don't recognize you")
        }
        // Prints "hello, world", because name is indeed equal to "world".
        
        (1, "zebra") < (2, "apple")   // true because 1 is less than 2; "zebra" and "apple" aren't compared
        (3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
        (4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog"
        
        ("blue", -1) < ("purple", 1)        // OK, evaluates to true
        ("blue", false) < ("purple", true)  // Error because < can't compare Boolean values
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 5. Ternary Conditional Operator [❌]
extension KotlinBasicOperatorsTests {
    func testTernaryConditionalOperator() throws {
        let swiftSource = """
        let question = false
        let answer1 = true
        let answer2 = false

        if question {
            answer1
        } else {
            answer2
        }

        let contentHeight = 40
        let hasHeader = true
        var rowHeight = contentHeight + (hasHeader ? 50 : 20)

        if hasHeader {
            rowHeight = contentHeight + 50
        } else {
            rowHeight = contentHeight + 20
        }
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 6. Nil-Coalescing Operator [❌]
extension KotlinBasicOperatorsTests {
    func testNilCoalescingOperator() throws {
        let swiftSource = """
        let defaultColorName = "red"
        var userDefinedColorName: String?   // defaults to nil

        var colorNameToUse = userDefinedColorName ?? defaultColorName
        // userDefinedColorName is nil, so colorNameToUse is set to the default of "red"
        
        userDefinedColorName = "green"
        colorNameToUse = userDefinedColorName ?? defaultColorName
        // userDefinedColorName isn't nil, so colorNameToUse is set to "green"
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 7. Range Operators [❌]
extension KotlinBasicOperatorsTests {
    // - Closed Range Operator [❌]
    func testClosedRangeOperator() throws {
        let swiftSource = """
        for index in 1...5 {
            print("\\(index) times 5 is \\(index * 5)")
        }
        // 1 times 5 is 5
        // 2 times 5 is 10
        // 3 times 5 is 15
        // 4 times 5 is 20
        // 5 times 5 is 25
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // - Half-Open Range Operator [❌]
    func testHalfOpenRangeOperator() throws {
        let swiftSource = """
        let names = ["Anna", "Alex", "Brian", "Jack"]
        let count = names.count
        for i in 0..<count {
            print("Person \\(i + 1) is called \\(names[i])")
        }
        // Person 1 is called Anna
        // Person 2 is called Alex
        // Person 3 is called Brian
        // Person 4 is called Jack
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // - One-Sided Ranges [❌]
    func testOneSidedRanges() throws {
        let swiftSource = """
        let names = ["Anna", "Alex", "Brian", "Jack"]
        for name in names[...2] {
            print(name)
        }

        //Anna
        //Alex
        //Brian

        for name in names[2...] {
            print(name)
        }

        // Brian
        // Jack

        for name in names[...2] {
            print(name)
        }
        // Anna
        // Alex
        // Brian

        for name in names[..<2] {
            print(name)
        }
        // Anna
        // Alex
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 8. Logical Operators [❌]
extension KotlinBasicOperatorsTests {
//    - Logical NOT (!a) [❌]
    func testLogicalNOT() throws {
        let swiftSource = """
        let allowedEntry = false
        if !allowedEntry {
            print("ACCESS DENIED")
        }
        // Prints "ACCESS DENIED"
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
        
    }
    
//    - Logical AND (a && b) [❌]
    func testLogicalAND() throws {
        let swiftSource = """
        let enteredDoorCode = true
        let passedRetinaScan = false
        if enteredDoorCode && passedRetinaScan {
            print("Welcome!")
        } else {
            print("ACCESS DENIED")
        }
        // Prints "ACCESS DENIED"
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }

//    - Logical OR Operator [❌]
    func testLogicalOR() throws {
        let swiftSource = """
        let hasDoorKey = false
        let knowsOverridePassword = true
        if hasDoorKey || knowsOverridePassword {
            print("Welcome!")
        } else {
            print("ACCESS DENIED")
        }
        // Prints "Welcome!"
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
//    - Combining Logical Operators [❌]
    func testCombiningLogicalOperators() throws {
        let swiftSource = """
        let enteredDoorCode = true
        let passedRetinaScan = true
        let hasDoorKey = false
        let knowsOverridePassword = true

        if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
            print("Welcome!")
        } else {
            print("ACCESS DENIED")
        }
        // Prints "Welcome!"
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
//    - Explicit Parentheses [❌]
    func testExplicitParentheses() throws {
        let swiftSource = """
        let enteredDoorCode = true
        let passedRetinaScan = true
        let hasDoorKey = false
        let knowsOverridePassword = false

        if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
            print("Welcome!")
        } else {
            print("ACCESS DENIED")
        }
        // Prints "Welcome!"
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
//extension KotlinBasicOperatorsTests {
//    func testTemplate() throws {
//        let swiftSource = """
//        b
//        """
//
//        let kotlinSource = """
//        """
//
//        try isEqual(
//            swiftSource: swiftSource,
//            kotlinSource: kotlinSource
//        )
//    }
//}
