//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

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

enum Language {
    case python
    case scala
}

// var hash2: [Int: Int] = [Int: Int]()
let targetLanguage = Language.python
let AST = try SyntaxParser.parse(source: swiftSource2.trim(for:targetLanguage))
let sourceCode = generate(from: AST, to:targetLanguage)

print("result >>")
print(sourceCode)

print("********************************************")

class Visitor: SyntaxRewriter {
    private let language: Language
    
    init(language: Language) {
        self.language = language
    }

    override func visit(_ token: TokenSyntax) -> Syntax {
        // print("token : \(token.tokenKind)")
        
        let newToken = generateSyntax(from: token, to: .python)
        return Syntax(newToken)
    }
    
    func generateSyntax(from token: TokenSyntax, to language: Language) -> TokenSyntax {
        switch language {
            case .python:
                return generatePythonSyntax(from: token)
            default:
                return generatePythonSyntax(from: token)
        }
    }
    
    func generatePythonSyntax(from token: TokenSyntax) -> TokenSyntax {
        print("token : \(token)")
        print("token.tokenKind : \(token.tokenKind)")
        print("token.tokens : \(token.tokens.map { $0.text })")
        
        switch token.tokenKind {
            case .leftSquareBracket:
                if token.nextToken?.nextToken?.tokenKind == .comma || token.nextToken?.nextToken?.tokenKind == .rightSquareBracket {
                    return token.withKind(token.tokenKind)
                } else {
                    return token.withKind(.leftBrace)
                }
            case .rightSquareBracket:
                if token.previousToken?.previousToken?.tokenKind == .comma || token.previousToken?.previousToken?.tokenKind == .leftSquareBracket {
                    return token.withKind(token.tokenKind)
                } else {
                    return token.withKind(.rightBrace)
                }
            case .structKeyword:
                return token.withKind(.classKeyword)
            case .identifier(let identifierName):
                return token.withKind(.identifier(identifierName))
                
            case .leftBrace:
                return token.withKind(.colon)
            case .rightBrace:
                return token.withKind(.unknown("")).withoutTrivia().withLeadingTrivia(Trivia.newlines(1))
                // return token.withKind(.unknown("")).withoutTrivia()
            case .letKeyword:
                return token.withKind(.unknown("")).withTrailingTrivia(Trivia.spaces(0))
            case .varKeyword:
                return token.withKind(.unknown("")).withTrailingTrivia(Trivia.spaces(0))
            case .integerLiteral(let text):
                let integerText = String(text.filter { ("0"..."9").contains($0) })
                return token.withKind(.integerLiteral("\(Int(integerText)!)"))
            case .eof:
                // print("eof : \(token)")
                return token.withKind(token.tokenKind)
            default:
                return token.withKind(token.tokenKind)
                // fatalError("no : \(token.tokenKind)!")
        }
    }
}

func generate(from AST: SourceFileSyntax, to language: Language) -> String {
    let transformedSyntax = Visitor(language: language).visit(AST)
    
    let sourceCode = transformedSyntax.description
        
    
    return sourceCode
}

extension String {
    func trim(for language: Language) -> String {
//        self
        self
            .eraseType()
            .replaceDataStructure()
            .replaceCommentStyle(for: language)
    }
    
    private func replaceDataStructure() -> String {
        self
            .replacingOccurrences(of: "[:]", with: "{}")
    }
    
    private func eraseType() -> String {
        // \[(.*?)\]|\<(.*?)\>|[a-zA-Z0-9]+\<(.*?)\>|:.[a-zA-Z0-9]+
        
        // dictionary =>
        // :.*?\<(.*?)\> => X
        // :.*?\[(.*?)\]+
        
        //generic =>
        // :.*?[a-zA-Z0-9]+\<(.*?)\>
        
        //array =>
        // : *?\[(.*?)\]
        // => better => :.*?[[]+[[a-zA-Z0-9]+]
        
        
        //need to check
        //:.*?\[(.*?)\]

        return self
            .replacingOccurrences(of: ": *?\\[(.*?)\\]+", with: "$1", options: [.regularExpression])
            .replacingOccurrences(of: ": *?[a-zA-Z0-9]+\\<(.*?)\\>", with: "$1", options: [.regularExpression])
            .replacingOccurrences(of: ": *?\\[(.*?)\\]", with: "$1", options: [.regularExpression])
            .replacingOccurrences(of: ":.*?[[]+[[a-zA-Z0-9]+]", with: "$1", options: [.regularExpression])
        
    }
    
    private func replaceCommentStyle(for language: Language) -> String {
        switch language {
            case .python:
                return self
                    .replacingOccurrences(of: "/**", with: "'''")
                    .replacingOccurrences(of: "/*", with: "'''")
                    .replacingOccurrences(of: "*/", with: "'''")
                    .replacingOccurrences(of: "///", with: "#")
                    .replacingOccurrences(of: "//", with: "#")
            default:
                return self
        }
    }
}


/// Swift source code example

//let numbers = [6, 5, 3, 8, 4, 2, 5, 4, 11]
//var sum = 0
//
//for val in numbers {
//    sum = sum+val
//}
//
//print(sum)
// sum: 48

/// Python target code example

//numbers = [6, 5, 3, 8, 4, 2, 5, 4, 11]
//sum = 0
//
//for val in numbers:
//    sum = sum+val
//
//print(sum)
//
//# sum: 48

let swiftSource = """
let numbers: [Int] = [0,1]
var sum = 0

for val in numbers {
    sum = sum+val
}

print(sum)
"""

extension TokenKind: CaseIterable {
    public static var allCases: [TokenKind] {
        [
            TokenKind.precedencegroupKeyword,
            TokenKind.protocolKeyword,
            TokenKind.structKeyword,
            TokenKind.subscriptKeyword,
            TokenKind.typealiasKeyword,
            TokenKind.varKeyword,
            TokenKind.fileprivateKeyword,
            TokenKind.internalKeyword,
            TokenKind.privateKeyword,
            TokenKind.publicKeyword,
            TokenKind.staticKeyword,
            TokenKind.deferKeyword,
            TokenKind.ifKeyword,
            TokenKind.guardKeyword,
            TokenKind.doKeyword,
            TokenKind.repeatKeyword,
            TokenKind.elseKeyword,
            TokenKind.forKeyword,
            TokenKind.inKeyword,
            TokenKind.whileKeyword,
            TokenKind.returnKeyword,
            TokenKind.breakKeyword,
            TokenKind.continueKeyword,
            TokenKind.fallthroughKeyword,
            TokenKind.switchKeyword,
            TokenKind.caseKeyword,
            TokenKind.defaultKeyword,
            TokenKind.whereKeyword,
            TokenKind.catchKeyword,
            TokenKind.throwKeyword,
            TokenKind.asKeyword,
            TokenKind.anyKeyword,
            TokenKind.falseKeyword,
            TokenKind.isKeyword,
            TokenKind.nilKeyword,
            TokenKind.rethrowsKeyword,
            TokenKind.superKeyword,
            TokenKind.selfKeyword,
            TokenKind.capitalSelfKeyword,
            TokenKind.trueKeyword,
            TokenKind.tryKeyword,
            TokenKind.throwsKeyword,
            TokenKind.__file__Keyword,
            TokenKind.__line__Keyword,
            TokenKind.__column__Keyword,
            TokenKind.__function__Keyword,
            TokenKind.__dso_handle__Keyword,
            TokenKind.wildcardKeyword,
            TokenKind.leftParen,
            TokenKind.rightParen,
            TokenKind.leftBrace,
            TokenKind.rightBrace,
            TokenKind.leftSquareBracket,
            TokenKind.rightSquareBracket,
            TokenKind.leftAngle,
            TokenKind.rightAngle,
            TokenKind.period,
            TokenKind.prefixPeriod,
            TokenKind.comma,
            TokenKind.ellipsis,
            TokenKind.colon,
            TokenKind.semicolon,
            TokenKind.equal,
            TokenKind.atSign,
            TokenKind.pound,
            TokenKind.prefixAmpersand,
            TokenKind.arrow,
            TokenKind.backtick,
            TokenKind.backslash,
            TokenKind.exclamationMark,
            TokenKind.postfixQuestionMark,
            TokenKind.infixQuestionMark,
            TokenKind.stringQuote,
            TokenKind.singleQuote,
            TokenKind.multilineStringQuote,
            TokenKind.poundKeyPathKeyword,
            TokenKind.poundLineKeyword,
            TokenKind.poundSelectorKeyword,
            TokenKind.poundFileKeyword,
            TokenKind.poundFileIDKeyword,
            TokenKind.poundFilePathKeyword,
            TokenKind.poundColumnKeyword,
            TokenKind.poundFunctionKeyword,
            TokenKind.poundDsohandleKeyword,
            TokenKind.poundAssertKeyword,
            TokenKind.poundSourceLocationKeyword,
            TokenKind.poundWarningKeyword,
            TokenKind.poundErrorKeyword,
            TokenKind.poundIfKeyword,
            TokenKind.poundElseKeyword,
            TokenKind.poundElseifKeyword,
            TokenKind.poundEndifKeyword,
            TokenKind.poundAvailableKeyword,
            TokenKind.poundFileLiteralKeyword,
            TokenKind.poundImageLiteralKeyword,
            TokenKind.poundColorLiteralKeyword,
            TokenKind.integerLiteral("need to implement :)"),
            TokenKind.floatingLiteral("need to implement :)"),
            TokenKind.stringLiteral("need to implement :)"),
            TokenKind.unknown("need to implement :)"),
            TokenKind.identifier("need to implement :)"),
            TokenKind.unspacedBinaryOperator("need to implement :)"),
            TokenKind.spacedBinaryOperator("need to implement :)"),
            TokenKind.postfixOperator("need to implement :)"),
            TokenKind.prefixOperator("need to implement :)"),
            TokenKind.dollarIdentifier("need to implement :)"),
            TokenKind.contextualKeyword("need to implement :)"),
            TokenKind.rawStringDelimiter("need to implement :)"),
            TokenKind.stringSegment("need to implement :)"),
            TokenKind.stringInterpolationAnchor,
            TokenKind.yield
        ]
    }
}

extension TokenKind {
    /// The textual representation of this token kind.
    public var text: String {
        switch self {
            case .eof: return ""
            case .associatedtypeKeyword: return "associatedtype"
            case .classKeyword: return "class"
            case .deinitKeyword: return "deinit"
            case .enumKeyword: return "enum"
            case .extensionKeyword: return "extension"
            case .funcKeyword: return "func"
            case .importKeyword: return "import"
            case .initKeyword: return "init"
            case .inoutKeyword: return "inout"
            case .letKeyword: return "let"
            case .operatorKeyword: return "operator"
            case .precedencegroupKeyword: return "precedencegroup"
            case .protocolKeyword: return "protocol"
            case .structKeyword: return "struct"
            case .subscriptKeyword: return "subscript"
            case .typealiasKeyword: return "typealias"
            case .varKeyword: return "var"
            case .fileprivateKeyword: return "fileprivate"
            case .internalKeyword: return "internal"
            case .privateKeyword: return "private"
            case .publicKeyword: return "public"
            case .staticKeyword: return "static"
            case .deferKeyword: return "defer"
            case .ifKeyword: return "if"
            case .guardKeyword: return "guard"
            case .doKeyword: return "do"
            case .repeatKeyword: return "repeat"
            case .elseKeyword: return "else"
            case .forKeyword: return "for"
            case .inKeyword: return "in"
            case .whileKeyword: return "while"
            case .returnKeyword: return "return"
            case .breakKeyword: return "break"
            case .continueKeyword: return "continue"
            case .fallthroughKeyword: return "fallthrough"
            case .switchKeyword: return "switch"
            case .caseKeyword: return "case"
            case .defaultKeyword: return "default"
            case .whereKeyword: return "where"
            case .catchKeyword: return "catch"
            case .throwKeyword: return "throw"
            case .asKeyword: return "as"
            case .anyKeyword: return "Any"
            case .falseKeyword: return "false"
            case .isKeyword: return "is"
            case .nilKeyword: return "nil"
            case .rethrowsKeyword: return "rethrows"
            case .superKeyword: return "super"
            case .selfKeyword: return "self"
            case .capitalSelfKeyword: return "Self"
            case .trueKeyword: return "true"
            case .tryKeyword: return "try"
            case .throwsKeyword: return "throws"
            case .__file__Keyword: return "__FILE__"
            case .__line__Keyword: return "__LINE__"
            case .__column__Keyword: return "__COLUMN__"
            case .__function__Keyword: return "__FUNCTION__"
            case .__dso_handle__Keyword: return "__DSO_HANDLE__"
            case .wildcardKeyword: return "_"
            case .leftParen: return "("
            case .rightParen: return ")"
            case .leftBrace: return "{"
            case .rightBrace: return "}"
            case .leftSquareBracket: return "["
            case .rightSquareBracket: return "]"
            case .leftAngle: return "<"
            case .rightAngle: return ">"
            case .period: return "."
            case .prefixPeriod: return "."
            case .comma: return ","
            case .ellipsis: return "..."
            case .colon: return ":"
            case .semicolon: return ";"
            case .equal: return "="
            case .atSign: return "@"
            case .pound: return "#"
            case .prefixAmpersand: return "&"
            case .arrow: return "->"
            case .backtick: return "`"
            case .backslash: return "\\"
            case .exclamationMark: return "!"
            case .postfixQuestionMark: return "?"
            case .infixQuestionMark: return "?"
            case .stringQuote: return "\""
            case .singleQuote: return "\'"
            case .multilineStringQuote: return "\"\"\""
            case .poundKeyPathKeyword: return "#keyPath"
            case .poundLineKeyword: return "#line"
            case .poundSelectorKeyword: return "#selector"
            case .poundFileKeyword: return "#file"
            case .poundFileIDKeyword: return "#fileID"
            case .poundFilePathKeyword: return "#filePath"
            case .poundColumnKeyword: return "#column"
            case .poundFunctionKeyword: return "#function"
            case .poundDsohandleKeyword: return "#dsohandle"
            case .poundAssertKeyword: return "#assert"
            case .poundSourceLocationKeyword: return "#sourceLocation"
            case .poundWarningKeyword: return "#warning"
            case .poundErrorKeyword: return "#error"
            case .poundIfKeyword: return "#if"
            case .poundElseKeyword: return "#else"
            case .poundElseifKeyword: return "#elseif"
            case .poundEndifKeyword: return "#endif"
            case .poundAvailableKeyword: return "#available"
            case .poundFileLiteralKeyword: return "#fileLiteral"
            case .poundImageLiteralKeyword: return "#imageLiteral"
            case .poundColorLiteralKeyword: return "#colorLiteral"
            case .integerLiteral(let text): return text
            case .floatingLiteral(let text): return text
            case .stringLiteral(let text): return text
            case .unknown(let text): return text
            case .identifier(let text): return text
            case .unspacedBinaryOperator(let text): return text
            case .spacedBinaryOperator(let text): return text
            case .postfixOperator(let text): return text
            case .prefixOperator(let text): return text
            case .dollarIdentifier(let text): return text
            case .contextualKeyword(let text): return text
            case .rawStringDelimiter(let text): return text
            case .stringSegment(let text): return text
            case .stringInterpolationAnchor: return ")"
            case .yield: return "yield"
        }
    }
}
