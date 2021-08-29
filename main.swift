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
    let count = names.count
    for i in 0..<count {
        print("Person \\(i + 1) is called \\(names[i])")
    }
    // Person 1 is called Anna
    // Person 2 is called Alex
    // Person 3 is called Brian
    // Person 4 is called Jack
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
