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
    let b = 10
    var a = 5
    a = b
    // a is now equal to 10

    let (x, y) = (1, 2)
    // x is equal to 1, and y is equal to 2

    if x == y {
        // This isn't valid, because x = y doesn't return a value.
    }
}
"""

//let age = -3
//assert(age >= 0, "A person's age can't be less than zero.")
//
//assert(age >= 0)
//
//if age > 10 {
//    print("You can ride the roller-coaster or the ferris wheel.")
//} else if age >= 0 {
//    print("You can ride the ferris wheel.")
//} else {
//    assertionFailure("A person's age can't be less than zero.")
//}

//enum SandwichError: Error {
//    case outOfCleanDishes
//    case missingIngredients(ingredientsName: String)
//}
//
//func canThrowAnError() throws {
//    // this function may or may not throw an error
//}
//
//do {
//    try canThrowAnError()
//    // no error was thrown
//} catch {
//    // an error was thrown
//}
//
//func makeASandwich() throws {}
//
//do {
//    try makeASandwich()
//} catch SandwichError.outOfCleanDishes {
//    // do something
//} catch SandwichError.missingIngredients(let ingredients) {
//    // do something
//}


//let possibleNumber: String? = "10"
//
//if let actualNumber = Int(possibleNumber) {
//    print("The string \\(possibleNumber) has an integer value of \\(actualNumber)")
//} else {
//    print("The string \\(possibleNumber) couldn't be converted to an integer")
//}

//let possibleNumber: String = "10"
//
//if let actualNumber = Int(possibleNumber) {
//    print("The string \\(possibleNumber) has an integer value of \\(actualNumber)")
//} else {
//    print("The string \\(possibleNumber) couldn't be converted to an integer")
//}


//let actualNumber = 10
//let possibleNumber = 20
//
//print("The string \"\(possibleNumber)\"")

// print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")
//print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")


let code = transpile(source)

print("*********************")
print("** code generation **")
print("*********************")

print("")
print(code)
print("")
