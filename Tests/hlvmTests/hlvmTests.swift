//
//  hlvmTests.swift
//  hlvmTests
//
//  Created by Seoksoon Jang on 2021/08/19.
//

import XCTest
import class Foundation.Bundle
// @testable import hlvm

final public class hlvmTests: XCTestCase {
    private let fromLanguage: Language = .swift
    private let toLanguage: Language = .kotlin
    
    func input(source: String) -> String {
        """
        \(fromLanguage.rawValue) \(Symbol.toArrow.rawValue) \(toLanguage.rawValue) {
            \(source)
        }
        """
    }
}

extension hlvmTests {
    func testIndent() throws {
        let notIndentedHLVMSyntax = """
        python {
                        for i in [0,1,2,3,4] {
        go {
            go {
        go {
                go { fire { print(i) }}
        }
        }
        }
            }
        }
        """

        let indentedSource = """
        for i in [0,1,2,3,4] {
            go {
                go {
                    go {
                        go { fire { print(i) }}
                    }
                }
            }
        }
        """
        // =>
        
        XCTAssertEqual(
            indent(source: takeCode(from: notIndentedHLVMSyntax), indentType: .space4),
            indentedSource
        )
    }
    
    func testTranspilePipeline() throws {
        let code1 = """
        python -> kotlin {
            numbers = [6, 5, 3, 8, 4, 2, 5, 4,
            print(f"numbers : {numbers}")
        }
        """
        
        let generatedCode1 = transpile(code1)

        let expectation1 = """
        val numbers = [6, 5, 3, 8, 4, 2, 5, 4,
        print("numbers : ${numbers}")
        """
        "
//        let code1 = """
//        python -> kotlin {
//            numbers = [6, 5, 3, 8, 4, 2, 5, 4, 11]
//            sum = 0
//
//            for num in numbers:
//                sum = sum+num
//
//            print(sum)
//        }
//        """
//
//        let generatedCode1 = transpile(code1)
//
//        let expectation1 = """
//        val numbers = arrayOf(6, 5, 3, 8, 4, 2, 5, 4, 11)
//        var sum = 0
//
//        for (val in numbers) {
//            sum = sum+val
//        }
//
//        print(sum)
//        """
        
        XCTAssertEqual(expectation1, generatedCode1)
        
    }
    
    func testRecognizedLanguage() throws {
        let code1 = """
        python -> clojure {

        }
        """

        var (targetLanguage, destinationLanguage) = recognizeLanguage(from: code1)

        XCTAssertEqual(targetLanguage, .python)
        XCTAssertEqual(destinationLanguage, .clojure)

        let code2 = """
        java {

        }
        """

        (targetLanguage, destinationLanguage) = recognizeLanguage(from: code2)

        XCTAssertEqual(targetLanguage, .swift)
        XCTAssertEqual(destinationLanguage, .java)

        let code3 = """
        {
                abc
        }
        """

        (targetLanguage, destinationLanguage) = recognizeLanguage(from: code3)

        XCTAssertEqual(targetLanguage, .swift)
        XCTAssertEqual(destinationLanguage, .unknown)


        let code4 = """
        """

        (targetLanguage, destinationLanguage) = recognizeLanguage(from: code4)

        XCTAssertEqual(targetLanguage, .swift)
        XCTAssertEqual(destinationLanguage, .unknown)

        let code5 = """
        kotlin -> {

        }
        """

        (targetLanguage, destinationLanguage) = recognizeLanguage(from: code5)

        XCTAssertEqual(targetLanguage, .kotlin)
        XCTAssertEqual(destinationLanguage, .unknown)
        
        let code6 = """
        -> {

        }
        """

        (targetLanguage, destinationLanguage) = recognizeLanguage(from: code6)

        XCTAssertEqual(targetLanguage, .unknown)
        XCTAssertEqual(destinationLanguage, .unknown)
    }
}
