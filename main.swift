//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation

let HLVM_IR = """
javascript {
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

let code = transpile(HLVM_IR)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
