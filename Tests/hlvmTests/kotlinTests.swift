import XCTest
import class Foundation.Bundle

// Python

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


final class kotlinTests: XCTestCase {
    func testKotlin() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)

        let fooBinary = productsDirectory.appendingPathComponent("hlvm")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
        #endif
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
