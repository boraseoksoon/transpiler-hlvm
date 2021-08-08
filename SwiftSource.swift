//
//  SwiftSource.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation

let swiftSource0 = """
for i in [0,1,2,3,4] {
    print("i : ", i)
}
"""

let swiftSource = """
python {
    for i in [0,1,2,3,4] {
        print("i : ", i)
    }
}
"""

let swiftSource2 = """
struct Human {
    var height: Set<String> = ["0", "1"]
    var age: Int<GoodType>
    var name: String
    var name2: String = ""
    var genderMap: [String:Any] = [:]
    var hash2: [Int: Int] = [Int: Int]()
    var hash3: [Int: Int]
}

let human = Human()
human.age
"""

let swiftSource3 = """
let myMap = [1:2]
"""

