//
//  Function.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/08.
//

import Foundation

//let source = """
//python {
//                for i in [0,1,2,3,4] {
//go {
//    go {
//go {
//        go { fire { print(i) }}
//}
//}
//}
//    }
//}
//"""

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

func indent(source: String,
            indentType: IndentationType = .tab) -> (Language, String) {
    func recurIndent(lines: [String],
                     index: Int = 0,
                     indentType: IndentationType,
                     indentLevel: Int = 0) -> [String] {
        guard indentLevel >= 0,
              lines.count - 1 >= index,
              case let line = lines[index]
            else { return lines }

        func calculate(newIndentLevel: Int,
                       indentType: IndentationType,
                       newLine: String) -> String {
            String(repeating:indentType.rawValue,
                   count: newIndentLevel >= 0 ? newIndentLevel : 0) + newLine
        }
        
        let leftBracket: Character = "{"
        let rightBracket: Character = "}"
        
        var newIndentLevel = indentLevel
        var newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let bracketOnlyString = String(newLine.lazy.filter(Set("{}").contains))
        
        let isConditionalBranch = (
            bracketOnlyString.hasPrefix("}")
            &&
            bracketOnlyString.hasSuffix("{")
        )

        if isConditionalBranch {
            newIndentLevel -= 1

            newLine = calculate(newIndentLevel: newIndentLevel,
                                indentType: indentType,
                                newLine: newLine)
            
            newIndentLevel += 1
            
        } else if newLine.last == leftBracket {
            newLine = calculate(newIndentLevel: newIndentLevel,
                                indentType: indentType,
                                newLine: newLine)
            
            newIndentLevel += 1
        } else if (
            newLine.last == rightBracket
            &&
            !hasPairBracket(string: bracketOnlyString)
        ) {
            newIndentLevel -= 1

            newLine = calculate(newIndentLevel: newIndentLevel,
                                indentType: indentType,
                                newLine: newLine)
        } else {
            newLine = calculate(newIndentLevel: newIndentLevel,
                                indentType: indentType,
                                newLine: newLine)
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

    func hasPairBracket(
        string: String,
        index: Int = 0,
        leftBrackets: [Character] = [],
        rightBrackets: [Character] = []
    ) -> Bool
    {
        let leftBracket: Character = "{"
        let rightBracket: Character = "}"
        
        guard string.contains(leftBracket) && string.contains(rightBracket)
            else { return false }
        
        guard string.count - 1 >= index
            else {
                return leftBrackets.count == rightBrackets.count ? true : false
            }
        
        let stringIndex = string.index(string.startIndex, offsetBy: index)
        let currentChar = string[stringIndex]
        
        var leftBrackets = leftBrackets
        var rightBrackets = rightBrackets

        if currentChar == leftBracket {
            leftBrackets.append(currentChar)
        } else if currentChar == rightBracket {
            rightBrackets.append(currentChar)
        }

        return hasPairBracket(
            string: string,
            index: index+1,
            leftBrackets: leftBrackets,
            rightBrackets: rightBrackets
        )
    }

    func takeCode(from source: String) -> String {
        .unknown == recognizeLanguage(from: source) ? source :
            (source
                .components(separatedBy: "\n")
                .dropFirst()
                .dropLast()
                .joined(separator: "\n"))
    }

    // TODO: if hasPairBracket failed, We need to report this fact to users
    // rather than just trying and returning a given incomplete source
    
//    guard hasPairBracket(string: source) else {
//        return (.unknown, source)
//    }
    
    let lines = takeCode(from: source)
        .components(separatedBy: "\n")
    
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
