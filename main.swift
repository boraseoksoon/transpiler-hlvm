//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation

let HLVM_IR = """
javascript {
    var serverResponseCode: Int? = 404
    // serverResponseCode contains an actual Int value of 404
    
    serverResponseCode = nil
    // serverResponseCode now contains no value
        
    let test: Int?
    var surveyAnswer: String?
    // surveyAnswer is automatically set to nil
}
"""

let code = transpile(HLVM_IR)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
