//
//  hlvmTests.swift
//  hlvmTests
//
//  Created by Seoksoon Jang on 2021/08/19.
//

import XCTest
import class Foundation.Bundle

final public class JavascriptTheBasicTests: XCTestCase {
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

// MARK: - 0. Edge cases [✅]
extension JavascriptTheBasicTests {
    func testSwiftSyntaxBug() throws {
        /// Possibly, SwiftSyntax bug?
        /// when escape character is used with tuple expression in print,
        /// node root is not divided line by line but token is linked all the way
        /// up uptil the top of source
        /// (here => let)
        let swiftSource = """
        let possibleNumber = 20
        print("The string \\(possibleNumber)")
        """

        let javascriptSource = """
        const possibleNumber = 20
        console.log(`The string ${possibleNumber}`)
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    func testEscapeCharacter() throws {
        let swiftSource = """
        print("The string \\(possibleNumber)")
        """

        let javascriptSource = """
        console.log(`The string ${possibleNumber}`)
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 1. Constants and Variables [✅]
extension JavascriptTheBasicTests {
    //    - Declaring Constants and Variables [✅]
    func testConstantAndVariable() throws {
        let swiftSource = """
        let maximumNumberOfLoginAttempts = 10
        var currentLoginAttempt = 0
        """

        let javascriptSource = """
        const maximumNumberOfLoginAttempts = 10
        let currentLoginAttempt = 0
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    //    - Type Annotations [✅]
    func testTypeAnnotation() throws {
        let swiftSource = """
        var red, green, blue: Double
        """

        let javascriptSource = """
        let red, green, blue;
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    //    - Naming Constants and Variables [✅]
    func testNamingConstantsAndVariables() throws {
        let swiftSource = """
        let π = 3.14159
        let 你好 = "你好世界"
        // note that in JS, emoji cannot be used as variable name.
        // need to give it exception
        // let 🐶🐮 = "dogcow"
        """

        let javascriptSource = """
        const π = 3.14159
        const 你好 = `你好世界`
        // note that in JS, emoji cannot be used as letiable name.
        // need to give it exception
        // const 🐶🐮 = `dogcow`
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    //    - Printing Constants and Variables [✅]
    func testPrint() throws {
        let swiftSource = """
        print(friendlyWelcome)
        print("The current value of friendlyWelcome is \\(friendlyWelcome)")
        """

        let javascriptSource = """
        console.log(friendlyWelcome)
        console.log(`The current value of friendlyWelcome is ${friendlyWelcome}`)
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 2. Comments [✅]
extension JavascriptTheBasicTests {
    // - Single-line comments [✅]
    func testSinglelineComments() throws {
        let swiftSource = """
        // This is a comment.
        """

        let javascriptSource = """
        // This is a comment.
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // - Multiline comments [❌]
    func testMultilineComments() throws {
        // indent function will indent to the left *, removing leading spaces.
        let swiftSource = """
        /* This is also a comment
        but is written over multiple lines. */
        /**
         * You can edit, run, and share this code.
         * play.kotlinlang.org
         */
        """

        // note that " *" is changed to "*"
        let javascriptSource = """
        /* This is also a comment
        but is written over multiple lines. */
        /**
         * You can edit, run, and share this code.
         * play.kotlinlang.org
         */
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // - Nested multiline comments [✅]
    func testNestedMultilineComments() throws {
        let swiftSource = """
        /* This is the start of the first multiline comment.
        /* This is the second, nested multiline comment. */
        This is the end of the first multiline comment. */
        """

        let javascriptSource = """
        /* This is the start of the first multiline comment.
        /* This is the second, nested multiline comment. */
        This is the end of the first multiline comment. */
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 3. Semicolons [✅]
extension JavascriptTheBasicTests {
    // - Optional semicolons [✅]
    func testOptionalSemicolons() throws {
        let swiftSource = """
        let cat = "🐱"; print(cat)
        """

        let javascriptSource = """
        const cat = `🐱`; console.log(cat)
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 4. Integers [❌]
extension JavascriptTheBasicTests {
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

        let javascriptSource = """
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        Number.MIN_SAFE_INTEGER
        Number.MAX_SAFE_INTEGER
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // Int [❌]
    func testInt() throws {
        let swiftSource = """
        """

        let javascriptSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // UInt [❌]
    func testUInt() throws {
        let swiftSource = """
        """

        let javascriptSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 5. Floating-Point Numbers [❌]
extension JavascriptTheBasicTests {
    // - Double [🌟]
    func testDouble() throws {
        let swiftSource = """
        """

        let javascriptSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    
    // - Float [🌟]
    func testFloat() throws {
        let swiftSource = """
        """

        let javascriptSource = """
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 6. Type Safety and Type Inference [❌]
extension JavascriptTheBasicTests {
    // - Type Inference [✅]
    func testTypeInference() throws {
        let swiftSource = """
        let meaningOfLife = 42
        let pi = 3.14159
        """

        // Javascript doesn't have Type to inference 😂
        let javascriptSource = """
        const meaningOfLife = 42
        const pi = 3.14159
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 7. Numeric Literals [❌]
extension JavascriptTheBasicTests {
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

        let javascriptSource = """
        const decimalInteger = 17
        const binaryInteger = 0b10001
        const octalInteger = 0o21
        const hexadecimalInteger = 0x11
        const decimalDouble = 12.1875
        const exponentDouble = 1.21875e1
        const hexadecimalDouble = 0xC.3p0
        const paddedDouble = 000123.456
        const oneMillion = 1_000_000
        const justOverOneMillion = 1_000_000.000_000_1
        """
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 8. Numeric Type Conversion [❌]
extension JavascriptTheBasicTests {
    func testNumericTypeConversion() throws {
        let swiftSource = """
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        UInt16(one)
        Int32(one)
        """

        let javascriptSource = """
        """

        // TODO :let twoThousandAndOne = twoThousand + UInt16(one)
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }

}

// MARK: - 9. Integer and Floating-Point Conversion [❌]
extension JavascriptTheBasicTests {
    func testFloatingConversion() throws {
        let swiftSource = """
        let three = 3
        let pointOneFourOneFiveNine = 0.14159
        let pi = Double(three) + pointOneFourOneFiveNine
        let integerPi = Int(pi)
        """

        let javascriptSource = """
        """
        
        // TODO:
        // let pi = Double(three) + pointOneFourOneFiveNine
        
        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 10. Type Aliases [❌]
extension JavascriptTheBasicTests {
    func testTypeAlias() throws {
        let swiftSource = """
        typealias AudioSample = UInt16
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 11. Boolean [❌]
extension JavascriptTheBasicTests {
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 12. Tuples  [❌]
extension JavascriptTheBasicTests {
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 13. Optionals [❌]
extension JavascriptTheBasicTests {
    // - nil [❌]
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
    // - If Statements and Forced Unwrapping [❌]
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
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

        let javascriptSource = """
        TBD
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 14. Error Handling [❌]
extension JavascriptTheBasicTests {
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

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}

// MARK: - 15. Assertions and Preconditions [❌]
extension JavascriptTheBasicTests {
    // Debugging with Assertions [❌]
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
        
        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }

    // Enforcing Preconditions [❌]
    func testEnforcingPreconditions() throws {
        let swiftSource = """
        let index = -1
        // In the implementation of a subscript...
        precondition(index > 0, "Index must be greater than zero.")
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
extension JavascriptTheBasicTests {
    func testTemplate() throws {
        let swiftSource = """
        """

        let javascriptSource = """
        """

        try isEqual(
            swiftSource: swiftSource,
            javascriptSource: javascriptSource
        )
    }
}
