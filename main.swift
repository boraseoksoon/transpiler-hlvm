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
    let names = ["Anna", "Alex", "Brian", "Jack"]
    for name in names[...2] {
        print(name)
    }

    //Anna
    //Alex
    //Brian

    for name in names[2...] {
        print(name)
    }

    // Brian
    // Jack

    for name in names[...2] {
        print(name)
    }
    // Anna
    // Alex
    // Brian

    for name in names[..<2] {
        print(name)
    }
    // Anna
    // Alex
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
