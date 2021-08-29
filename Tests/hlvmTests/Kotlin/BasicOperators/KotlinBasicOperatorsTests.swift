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

// MARK: - 1. Assignment Operator [✅]
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

// MARK: - 2. Arithmetic Operators [✅]
extension KotlinBasicOperatorsTests {
    // - Addition (+)  [✅]
    func testAddition() throws {
        let swiftSource = """
        1 + 2       // equals 3
        """

        let kotlinSource = """
        1 + 2       // equals 3
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Subtraction (-) [✅]
    func testSubtraction() throws {
        let swiftSource = """
        5 - 3       // equals 2
        """

        let kotlinSource = """
        5 - 3       // equals 2
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    // - Multiplication (*) [✅]
    func testMultiplication() throws {
        let swiftSource = """
        2 * 3       // equals 6
        """

        let kotlinSource = """
        2 * 3       // equals 6
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    // - Division (/) [✅]
    func testDivision() throws {
        let swiftSource = """
        10.0 / 2.5  // equals 4.0
        """

        let kotlinSource = """
        10.0 / 2.5  // equals 4.0
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    // - Remainder Operator [✅]
    func testRemainderOperator() throws {
        let swiftSource = """
        9 % 4
        """

        let kotlinSource = """
        9 % 4
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    // - Unary Minus Operator [✅]
    func testUnaryMinusOperator() throws {
        let swiftSource = """
        let three = 3
        let minusThree = -three       // minusThree equals -3
        let plusThree = -minusThree   // plusThree equals 3, or "minus minus three"
        """

        let kotlinSource = """
        val three = 3
        val minusThree = -three       // minusThree equals -3
        val plusThree = -minusThree   // plusThree equals 3, or "minus minus three"
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    // - Unary Plus Operator [✅]
    func testUnaryPlusOperator() throws {
        let swiftSource = """
        let minusSix = -6
        let alsoMinusSix = +minusSix  // alsoMinusSix equals -6
        """

        let kotlinSource = """
        val minusSix = -6
        val alsoMinusSix = +minusSix  // alsoMinusSix equals -6
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 3. Compound Assignment Operators [✅]
extension KotlinBasicOperatorsTests {
    func testCompoundAssignmentOperators() throws {
        let swiftSource = """
        var a = 1
        a += 2
        """

        let kotlinSource = """
        var a = 1
        a += 2
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
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

        let kotlinSource = """
        1 == 1   // true because 1 is equal to 1
        2 != 1   // true because 2 isn't equal to 1
        2 > 1    // true because 2 is greater than 1
        1 < 2    // true because 1 is less than 2
        1 >= 1   // true because 1 is greater than or equal to 1
        2 <= 1   // false because 2 isn't less than or equal to 1
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 5. Ternary Conditional Operator [✅]
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

        let kotlinSource = """
        val question = false
        val answer1 = true
        val answer2 = false

        if (question) {
            answer1
        } else {
            answer2
        }

        val contentHeight = 40
        val hasHeader = true
        var rowHeight = contentHeight + (if (hasHeader) 50 else 20)

        if (hasHeader) {
            rowHeight = contentHeight + 50
        } else {
            rowHeight = contentHeight + 20
        }
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 6. Nil-Coalescing Operator [✅]
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

        let kotlinSource = """
        val defaultColorName = "red"
        var userDefinedColorName: String? = null // defaults to null

        var colorNameToUse = userDefinedColorName ?: defaultColorName
        // userDefinedColorName is null, so colorNameToUse is set to the default of "red"

        userDefinedColorName = "green"
        colorNameToUse = userDefinedColorName ?: defaultColorName
        // userDefinedColorName isn't null, so colorNameToUse is set to "green"
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 7. Range Operators [❌]
extension KotlinBasicOperatorsTests {
    // - Closed Range Operator [✅]
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

        let kotlinSource = """
        for (index in 1..5) {
            print("${index} times 5 is ${index * 5}")
        }
        // 1 times 5 is 5
        // 2 times 5 is 10
        // 3 times 5 is 15
        // 4 times 5 is 20
        // 5 times 5 is 25
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Half-Open Range Operator [✅]
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

        let kotlinSource = """
        val names = arrayOf("Anna","Alex","Brian","Jack")
        val count = names.count()
        for (i in 0..count - 1) {
            print("Person ${i + 1} is called ${names[i]}")
        }
        // Person 1 is called Anna
        // Person 2 is called Alex
        // Person 3 is called Brian
        // Person 4 is called Jack
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - One-Sided Ranges [❌]
    func testOneSidedRanges() throws {
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

// MARK: - 99. TEST [❌]
extension KotlinBasicOperatorsTests {
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
