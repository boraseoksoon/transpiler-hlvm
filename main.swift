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
    if turnipsAreDelicious {
    switch a {
                    good {
fire{
            }
        }
}
"""

let isNice = true
let isTrue = true
let isGood = false
if isNice  , isTrue     , isGood {
    print("pass!")
}

//let orangesAreOrange = true
//let turnipsAreDelicious = false
//if turnipsAreDelicious {
//    print("Mmm, tasty turnips!")
//} else {
//    print("Eww, turnips are horrible.")
//}
//// Prints "Eww, turnips are horrible."
//let i = 1
//if i == 1 {
//    // this example will compile successfully
//}


let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
