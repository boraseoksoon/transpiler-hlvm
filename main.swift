//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation

let HLVM_IR = """
javascript {
    let orangesAreOrange = true
    let turnipsAreDelicious = false
    if turnipsAreDelicious {
        print("Mmm, tasty turnips!")
    } else {
        print("Eww, turnips are horrible.")
    }
    // Prints "Eww, turnips are horrible."
    let i = 1
    if i == 1 {
        // this example will compile successfully
    }
    
    let isGood = true
    var isNice = true
    
    if isGood, isNice {
        print("pass!")
    } else {
        print("can't pass!")
    }
}
"""

let code = transpile(HLVM_IR)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
