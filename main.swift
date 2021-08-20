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
    let a = true
    let b = 1000
    let c = 0

    let d = a ? b : c
    print("d is \\(d)")
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")

print(code)

print("")
