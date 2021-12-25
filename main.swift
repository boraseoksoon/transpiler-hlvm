//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation

let HLVM_IR = """
javascript {
    let possibleNumber: String = "10"

    if let actualNumber = Int(possibleNumber) {
        print("The string \\(possibleNumber) has an integer value of \\(actualNumber)")
    } else {
        print("The string \\(possibleNumber) couldn't be converted to an integer")
    }
}
"""

let code = transpile(HLVM_IR)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
