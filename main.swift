//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation

let HLVM_IR = """
javascript {
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
}
"""

let code = transpile(HLVM_IR)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
