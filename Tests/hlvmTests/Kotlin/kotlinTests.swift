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
        let code1 = transpile(input(source: swiftSource), to: Language.kotlin)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let code2 = kotlinSource
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(code1)
        print("**** divider *****")
        print(code2)
        XCTAssertEqual(code1, code2)
    }
}

// MARK: - 0. Edge cases [❌]
extension kotlinTests {
    func testSwiftSyntaxBug() throws {
        /// Possibly, SwiftSyntax bug?
        /// when escape character is used with tuple expression in print,
        /// node root is not divided line by line but token is linked all the way
        /// up uptil the top of source
        /// (here => let)
        let swiftSource = """
        let possibleNumber = 20
        print("The string \"\\(possibleNumber)\"")
        """

        let kotlinSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    func testEscapeCharacter() throws {
        let swiftSource = """
        print("The string \" \\(possibleNumber)\"")
        """

        let kotlinSource = """
        print("The string \"${possibleNumber}\"")
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 1. Constants and Variables [✅]
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

// MARK: - 2. Comments [✅]
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

// MARK: - 3. Semicolons [✅]
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

// MARK: - 4. Integers [✅]
extension kotlinTests {
    // Integer Bounds [✅]
    func testMaximumInteger() throws {
        let swiftSource = """
        UInt8.min
        UInt8.max
        UInt16.min
        UInt16.max
        UInt32.min
        UInt32.max
        UInt64.min
        UInt64.max
        Int8.min
        Int8.max
        Int16.min
        Int16.max
        Int32.min
        Int32.max
        Int64.min
        Int64.max
        """

        let kotlinSource = """
        UInt.MIN_VALUE
        UInt.MAX_VALUE
        UInt.MIN_VALUE
        UInt.MAX_VALUE
        UInt.MIN_VALUE
        UInt.MAX_VALUE
        UInt.MIN_VALUE
        UInt.MAX_VALUE
        Int.MIN_VALUE
        Int.MAX_VALUE
        Int.MIN_VALUE
        Int.MAX_VALUE
        Int.MIN_VALUE
        Int.MAX_VALUE
        Int.MIN_VALUE
        Int.MAX_VALUE
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

// MARK: - 5. Floating-Point Numbers [✅]
extension kotlinTests {
    // - Double [🌟]
    func testDouble() throws {
        let swiftSource = """
        """

        let kotlinSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Float [🌟]
    func testFloat() throws {
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

// MARK: - 6. Type Safety and Type Inference [✅]
extension kotlinTests {
    // - Type Inference [🌟]
    func testTypeInference() throws {
        let swiftSource = """
        let meaningOfLife = 42
        let pi = 3.14159
        """

        let kotlinSource = """
        val meaningOfLife = 42
        val pi = 3.14159
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 7. Numeric Literals [✅]
extension kotlinTests {
    func testNumericLiteral() throws {
        let swiftSource = """
        let decimalInteger = 17
        let binaryInteger = 0b10001
        let octalInteger = 0o21
        let hexadecimalInteger = 0x11
        let decimalDouble = 12.1875
        let exponentDouble = 1.21875e1
        let hexadecimalDouble = 0xC.3p0
        let paddedDouble = 000123.456
        let oneMillion = 1_000_000
        let justOverOneMillion = 1_000_000.000_000_1
        """

        let kotlinSource = """
        val decimalInteger = 17
        val binaryInteger = 0b10001
        val octalInteger = 17
        val hexadecimalInteger = 0x11
        val decimalDouble = 12.1875
        val exponentDouble = 1.21875e1
        val hexadecimalDouble = 12.1875
        val paddedDouble = 000123.456
        val oneMillion = 1_000_000
        val justOverOneMillion = 1_000_000.000_000_1
        """
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 8. Numeric Type Conversion [✅]
extension kotlinTests {
    func testNumericTypeConversion() throws {
        let swiftSource = """
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        UInt16(one)
        Int32(one)
        """

        let kotlinSource = """
        val twoThousand: Int = 2_000
        val one: Int = 1
        one.toUInt()
        one.toInt()
        """

        // TODO :let twoThousandAndOne = twoThousand + UInt16(one)
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }

}

// MARK: - 9. Integer and Floating-Point Conversion [✅]
extension kotlinTests {
    func testFloatingConversion() throws {
        let swiftSource = """
        let three = 3
        let pointOneFourOneFiveNine = 0.14159
        let pi = Double(three) + pointOneFourOneFiveNine
        let integerPi = Int(pi)
        """

        let kotlinSource = """
        val three = 3
        val pointOneFourOneFiveNine = 0.14159
        val pi = three.toDouble() + pointOneFourOneFiveNine
        val integerPi = pi.toInt()
        """
        
        // TODO:
        // let pi = Double(three) + pointOneFourOneFiveNine
        
        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 10. Type Aliases [✅]
extension kotlinTests {
    func testTypeAlias() throws {
        let swiftSource = """
        typealias AudioSample = UInt16
        """

        let kotlinSource = """
        typealias AudioSample = Int
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 11. Boolean [✅]
extension kotlinTests {
    func testBoolean() throws {
        let swiftSource = """
        let orangesAreOrange = true
        let turnipsAreDelicious = false
        if turnipsAreDelicious {
            print("Mmm, tasty turnips!")
        } else {
            print("Eww, turnips are horrible.")
        }
        // Prints "Eww, turnips are horrible."
        let i = 1
        if i == 1 {
            // this example will compile successfully
        }
        
        let isGood = true
        var isNice = true
        
        if isGood, isNice {
            print("pass!")
        } else {
            print("can't pass!")
        }
        """

        let kotlinSource = """
        val orangesAreOrange = true
        val turnipsAreDelicious = false
        if (turnipsAreDelicious) {
            print("Mmm, tasty turnips!")
        } else {
            print("Eww, turnips are horrible.")
        }
        // Prints "Eww, turnips are horrible."
        val i = 1
        if (i == 1) {
            // this example will compile successfully
        }
        
        val isGood = true
        var isNice = true
        
        if (isGood && isNice) {
            print("pass!")
        } else {
            print("can't pass!")
        }
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 12. Tuples  [✅]
extension kotlinTests {
    func testTuples() throws {
//        let swiftSource = """
//        let http404Error = (404, "Not Found")
//        """
//
//        let kotlinSource = """
//        val http404Error = arrayOf(404, "Not Found")
//        """

        let swiftSource = """
        let http404Error = (404, "Not Found")
        let (statusCode, statusMessage) = http404Error
        print("The status code is \\(statusCode)")
        // Prints "The status code is 404"
        print("The status message is \\(statusMessage)")
        // Prints "The status message is Not Found"

        let (justTheStatusCode, _) = http404Error
        print("The status code is \\(justTheStatusCode)")
        // Prints "The status code is 404"

        print("The status code is \\(http404Error.0)")
        // Prints "The status code is 404"
        print("The status message is \\(http404Error.1)")
        // Prints "The status message is Not Found"

        let http200Status = (statusCode: 200, description: "OK")
        print("The status code is \\(http200Status.statusCode)")
        // Prints "The status code is 200"
        print("The status message is \\(http200Status.description)")
        // Prints "The status message is OK"
        """

        let kotlinSource = """
        val http404Error = arrayOf(404, "Not Found")
        val (statusCode, statusMessage) = http404Error
        print("The status code is ${statusCode}")
        // Prints "The status code is 404"
        print("The status message is ${statusMessage}")
        // Prints "The status message is Not Found"

        val (justTheStatusCode, _) = http404Error
        print("The status code is ${justTheStatusCode}")
        // Prints "The status code is 404"

        print("The status code is ${http404Error[0]}")
        // Prints "The status code is 404"
        print("The status message is ${http404Error[1]}")
        // Prints "The status message is Not Found"

        val http200Status = mapOf("statusCode" to 200, "description" to "OK")
        print("The status code is ${http200Status["statusCode"]}")
        // Prints "The status code is 200"
        print("The status message is ${http200Status["description"]}")
        // Prints "The status message is OK"
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 13. Optionals [❌]
extension kotlinTests {
    // - nil [✅]
    func testNil() throws {
        let swiftSource = """
        var serverResponseCode: Int? = 404
        // serverResponseCode contains an actual Int value of 404
        
        serverResponseCode = nil
        // serverResponseCode now contains no value
            
        let test: Int?
        var surveyAnswer: String?
        // surveyAnswer is automatically set to nil
        """

        let kotlinSource = """
        var serverResponseCode: Int? = 404
        // serverResponseCode contains an actual Int value of 404

        serverResponseCode = null
        // serverResponseCode now contains no value

        val test: Int?
        var surveyAnswer: String?
        // surveyAnswer is automatically set to null
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    // - If Statements and Forced Unwrapping [✅]
    func testIfStatementsAndForcedUnwrapping() throws {
        let swiftSource = """
        var convertedNumber: Int?

        if convertedNumber != nil {
            print("convertedNumber contains some integer value.")
        }
        // Prints "convertedNumber contains some integer value."

        if convertedNumber != nil {
            print("convertedNumber has an integer value of \\(convertedNumber!).")
        }
        // Prints "convertedNumber has an integer value of 123."
        """

        let kotlinSource = """
        var convertedNumber: Int? = null

        if (convertedNumber != null) {
            print("convertedNumber contains some integer value.")
        }
        // Prints "convertedNumber contains some integer value."

        if (convertedNumber != null) {
            print("convertedNumber has an integer value of ${convertedNumber!!}.")
        }
        // Prints "convertedNumber has an integer value of 123."
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Optional Binding [❌]
    func testOptionalBinding() throws {
        let swiftSource = """
        let possibleNumber: String = "10"

        if let actualNumber = Int(possibleNumber) {
            print("The string \\(possibleNumber) has an integer value of \\(actualNumber)")
        } else {
            print("The string \\(possibleNumber) couldn't be converted to an integer")
        }
        """

        let kotlinSource = """
        val possibleNumber: String = "10"
        
        val actualNumber = possibleNumber.toInt()
        if (actualNumber != null) {
           print("The string ${actualNumber} has an integer value of ${actualNumber}")
        } else {
            print("The string ${possibleNumber} couldn't be converted to an integer")
        }
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
    
    // - Implicitly Unwrapped Optionals [❌]
    func testImplicitlyUnwrappedOptionals() throws {
        let swiftSource = """
        let possibleString: String? = "An optional string."
        let forcedString: String = possibleString! // requires an exclamation point

        let assumedString: String! = "An implicitly unwrapped optional string."
        let implicitString: String = assumedString // no need for an exclamation point
        """

        let kotlinSource = """
        TBD
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 14. Error Handling [❌]
extension kotlinTests {
    func testTryCatchBasic() throws {
        let swiftSource = """
        func canThrowAnError() throws {
            // this function may or may not throw an error
        }

        do {
            try canThrowAnError()
            // no error was thrown
        } catch {
            // an error was thrown
        }
        
        func makeASandwich() throws {
            //
        }

        do {
            try makeASandwich()
            eatASandwich()
        } catch SandwichError.outOfCleanDishes {
            washDishes()
        } catch SandwichError.missingIngredients(let ingredients) {
            buyGroceries(ingredients)
        }
        
        """

        let kotlinSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 15. Assertions and Preconditions [❌]
extension kotlinTests {
    // Debugging with Assertions [✅]
    func testAssert() throws {
        let swiftSource = """
        let age = -3
        assert(age >= 0, "A person's age can't be less than zero.")
        // This assertion fails because -3 isn't >= 0.

        assert(age >= 0)

        if age > 10 {
            print("You can ride the roller-coaster or the ferris wheel.")
        } else if age >= 0 {
            print("You can ride the ferris wheel.")
        } else {
            assertionFailure("A person's age can't be less than zero.")
        }
        """
        
        let kotlinSource = """
        val age = -3
        assert(age >= 0) { "A person's age can't be less than zero." }
        // This assertion fails because -3 isn't >= 0.

        assert(age >= 0)

        if (age > 10) {
            print("You can ride the roller-coaster or the ferris wheel.")
        } else if (age >= 0) {
            print("You can ride the ferris wheel.")
        } else {
            assert(false) { "A person's age can't be less than zero." }
        }
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }

    // Enforcing Preconditions [✅]
    func testEnforcingPreconditions() throws {
        let swiftSource = """
        let index = -1
        // In the implementation of a subscript...
        precondition(index > 0, "Index must be greater than zero.")
        """

        let kotlinSource = """
        val index = -1
        // In the implementation of a subscript...
        require(index > 0) { "Index must be greater than zero." }
        """

        try isEqual(
            swiftSource: swiftSource,
            kotlinSource: kotlinSource
        )
    }
}

// MARK: - 99. TEST [❌]
extension kotlinTests {
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
