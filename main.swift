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
let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
print("The status code is \\(statusCode)")
// Prints "The status code is 404"
print("The status message is \\(statusMessage)")
// Prints "The status message is Not Found"

let (justTheStatusCode, _) = http404Error
print("The status code is \\(justTheStatusCode)")
// Prints "The status code is 404"

print("The status code is \\(http404Error.0)")
// Prints "The status code is 404"
print("The status message is \\(http404Error.1)")
// Prints "The status message is Not Found"

let http200Status = (statusCode: 200, description: "OK")
print("The status code is \\(http200Status.statusCode)")
// Prints "The status code is 200"
print("The status message is \\(http200Status.description)")
// Prints "The status message is OK"
}
"""
// val http200Status = mapOf("statusCode" to 200, "description" to "OK")



let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
