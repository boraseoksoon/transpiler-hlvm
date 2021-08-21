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
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        UInt16(one)
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")

print(code)

print("")

print("take : \(Int(0o21))")
