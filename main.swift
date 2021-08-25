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
    var serverResponseCode: Int? = 404
    // serverResponseCode contains an actual Int value of 404
    
    serverResponseCode = nil
    // serverResponseCode now contains no value
        
    let test: Int?
    var surveyAnswer: String?
    // surveyAnswer is automatically set to nil
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
