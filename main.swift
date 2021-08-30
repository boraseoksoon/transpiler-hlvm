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
            1 == 1   // true because 1 is equal to 1
            2 != 1   // true because 2 isn't equal to 1
            2 > 1    // true because 2 is greater than 1
            1 < 2    // true because 1 is less than 2
            1 >= 1   // true because 1 is greater than or equal to 1
            2 <= 1   // false because 2 isn't less than or equal to 1
            
            let name = "world"
            if name == "world" {
                print("hello, world")
            } else {
                print("I'm sorry \\(name), but I don't recognize you")
            }
            // Prints "hello, world", because name is indeed equal to "world".
            
            (1, "zebra") < (2, "apple")   // true because 1 is less than 2; "zebra" and "apple" aren't compared
            (3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
            (4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog"
            
            ("blue", -1) < ("purple", 1)        // OK, evaluates to true
            ("blue", false) < ("purple", true)  // Error because < can't compare Boolean values
}
"""

let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
