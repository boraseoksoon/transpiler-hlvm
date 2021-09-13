//
//  Indentation.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/09/13.
//

import Foundation

// indent ex:

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

// =>

//    for i in [0,1,2,3,4] {
//        go {
//            go {
//                go {
//                    go { fire { print(i) }}
//                }
//            }
//        }
//    }

// TODO: due to indent type, it may be possible for isEqual code test to fail.
public func indent(source: String,
                   indentType: IndentationType = .tab) -> String {
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

    let lines = source.components(separatedBy: "\n")
    let res = recurIndent(lines: lines,
                          indentType: indentType)
        .joined(separator: "\n")
    
    return res
}

public func takeCode(from hlvmSyntax: String) -> String {
    Array((hlvmSyntax
            .components(separatedBy: "\n")
            .dropFirst()
            .dropLast()))
        .joined(separator: "\n")
}

public func recognizeLanguage(from source: String) -> (Language, Language) {
    guard case let lines = source.components(separatedBy: "\n"),
          let firstLine = lines.first, let lastLine = lines.last,
          case let trimmedFirstLine = firstLine.trimmingCharacters(in: .whitespacesAndNewlines),
          trimmedFirstLine.hasSuffix("{"), trimmedFirstLine.dropLast().last == " ",
          case let trimmedLastLine = lastLine.trimmingCharacters(in: .whitespacesAndNewlines),
          trimmedLastLine.hasSuffix("}"), trimmedLastLine.count == 1
        else { return (.swift, .unknown) }
    
    let languageNames = firstLine
        .components(separatedBy: Symbol.toArrow.rawValue)
        .map {
            Language(rawValue: $0
                        .trimmingCharacters(in: .alphanumerics.inverted)
                        .lowercased()) ?? .unknown
        }
    
    let (targetLanguage, destinationLanguage) = (
        firstLine.contains(Symbol.toArrow.rawValue) ?
        (languageNames.first ?? .swift, languageNames.last ?? .unknown) :
        (.swift, languageNames.first ?? .unknown)
    )
    
    return (targetLanguage, destinationLanguage)
}

public func hasPairBracket(
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

public enum IndentationType: String {
    case tab = "\t"
    case space2 = "  "
    case space4 = "    "
    case test = "!"
}

public enum Bracket: Character {
    case leftCurly = "{"
    case rigthCurly = "}"
}

