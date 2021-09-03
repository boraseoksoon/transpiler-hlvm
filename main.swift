//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

let source = """
python {
    let name = "JSS"
    print("hey : \\(name)")
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
