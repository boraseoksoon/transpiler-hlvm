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
    let octalInteger = 0o21
    let hexadecimalDouble = 0xC.3p0
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
