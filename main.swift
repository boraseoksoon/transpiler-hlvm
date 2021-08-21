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
    let three = 3
    let pointOneFourOneFiveNine = 0.14159
    let pi = Double(three) + pointOneFourOneFiveNine
    let integerPi = Int(pi)
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
