//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation

let HLVM_IR = """
javascript {
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        UInt16(twoThousand)
        Int32(one)
}
"""

let code = transpile(HLVM_IR)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
