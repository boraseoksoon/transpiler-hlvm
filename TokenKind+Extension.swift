//
//  TokenKind+Extension.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation
import SwiftSyntax

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
