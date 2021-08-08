//
//  Function.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/08.
//

import Foundation

let source = """
python {
                for i in [0,1,2,3,4] {
go {
    go {
go {
        go { fire { print(i) }}
}
}
}
    }
}
"""

//let (language, indentedSource) = indent(source: source)
//
//print(language)
//print(indentedSource)

//python
//for i in [0,1,2,3,4] {
//    go {
//        go {
//            go {
//                go { fire { print(i) }}
//            }
//        }
//    }
//}

func indent(source: String, indentType: IndentationType = .tab) -> (Language, String) {
    func recurIndent(lines: [String],
                     index: Int = 0,
                     indentType: IndentationType,
                     indentLevel: Int = 0) -> [String] {
        guard indentLevel >= 0,
              lines.count - 1 >= index,
              case let line = lines[index]
            else { return lines }

        let leftCurlyBracket: Character = "{"
        let rightCurlyBracket: Character = "}"
        
        var newIndentLevel = indentLevel
        var newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let curlyBracketOnlyString = String(newLine.lazy.filter(Set("{}").contains))
        
        if newLine.last == leftCurlyBracket {
            let indentation = String(repeating:indentType.rawValue,
                                     count: newIndentLevel >= 0 ? newIndentLevel : 0)
            newLine = indentation + newLine

            newIndentLevel += 1
        } else if (
            newLine.last == rightCurlyBracket
            &&
            !hasPairCurlyBracket(string: curlyBracketOnlyString)
        ) {
            newIndentLevel -= 1

            let indentation = String(repeating:indentType.rawValue,
                                     count: newIndentLevel >= 0 ? newIndentLevel : 0)
            newLine = indentation + newLine
        } else {
            let indentation = String(repeating:indentType.rawValue,
                                     count: newIndentLevel >= 0 ? newIndentLevel : 0)
            newLine = indentation + newLine
        }
        
        var lines = lines
        lines[index] = newLine

        return recurIndent(
            lines: lines,
            index: index + 1,
            indentType: indentType,
            indentLevel:newIndentLevel
        )
    }

    func hasPairCurlyBracket(
        string: String,
        index: Int = 0,
        leftCurlyBrackets: [Character] = [],
        rightCurlyBrackets: [Character] = []
    ) -> Bool
    {
        let leftCurlyBracket: Character = "{"
        let rightCurlyBracket: Character = "}"
        
        guard string.contains(leftCurlyBracket) && string.contains(rightCurlyBracket)
            else { return false }
        
        guard string.count - 1 >= index else {
            return leftCurlyBrackets.count == rightCurlyBrackets.count ? true : false
        }
        
        let stringIndex = string.index(string.startIndex, offsetBy: index)
        let currentChar = string[stringIndex]
        
        var leftCurlyBrackets = leftCurlyBrackets
        var rightCurlyBrackets = rightCurlyBrackets

        if currentChar == leftCurlyBracket {
            leftCurlyBrackets.append(currentChar)
        } else if currentChar == rightCurlyBracket {
            rightCurlyBrackets.append(currentChar)
        }

        return hasPairCurlyBracket(
            string: string,
            index: index+1,
            leftCurlyBrackets: leftCurlyBrackets,
            rightCurlyBrackets: rightCurlyBrackets
        )
    }

    func takeCode(from source: String) -> String {
        guard .unknown != recognizeLanguage(from: source) else { return source }
        return source
            .components(separatedBy: "\n")
            .dropFirst()
            .dropLast()
            .joined(separator: "\n")
    }

    guard hasPairCurlyBracket(string: source) else { return (.unknown, source) }
    
    let lines = takeCode(from: source).components(separatedBy: "\n")
    
    return (
        recognizeLanguage(from: source),
        recurIndent(lines: lines, indentType: indentType)
            .joined(separator: "\n")
    )
}

func recognizeLanguage(from source: String) -> Language {
    let lines = source.components(separatedBy: "\n")
    guard let firstLine = lines.first, let lastLine = lines.last
        else { return .unknown }
    
    let trimmedFirstLine = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmedFirstLine.hasSuffix("{"), trimmedFirstLine.dropLast().last == " "
        else { return .unknown }
    
    let trimmedLastLine = lastLine.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmedLastLine.hasSuffix("}"), trimmedLastLine.count == 1
        else { return .unknown }
    
    let languageName = firstLine
        .trimmingCharacters(in: .alphanumerics.inverted)
        .lowercased()
    
    let language = Language(rawValue: languageName)
    
    return language == nil ? .unknown : language!
}

enum IndentationType: String {
    case tab = "\t"
    case space2 = "  "
    case space4 = "    "
    case test = "!"
}

enum Bracket: Character {
    case leftCurly = "{"
    case rigthCurly = "}"
}
