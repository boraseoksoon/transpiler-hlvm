//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let source = """
kotlin {
    var convertedNumber: Int?

    if convertedNumber != nil {
        print("convertedNumber contains some integer value.")
    }
    // Prints "convertedNumber contains some integer value."

    if convertedNumber != nil {
        print("convertedNumber has an integer value of \\(convertedNumber!).")
    }
    // Prints "convertedNumber has an integer value of 123."
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
