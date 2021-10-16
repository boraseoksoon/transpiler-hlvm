//
//  Finalization.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/09/13.
//

import Foundation

// TODO: REMOVE ALL
// TODO: SHOULD NOT BE USED, JUST FOR PROTOTYPING. LET'S SAY print("let is good!")
public func finalize(source: String, for language: Language) -> String {
    switch language {
        case .kotlin:
            return finalizeKotlin(source: source)
        case .python:
            return finalizePython(source: source)
        case .javascript:
            return finalizeJavascript(source: source)
        default:
            return source
    }
}

private func finalizeJavascript(source: String) -> String {
    source
        .replacingOccurrences(of: "let", with: "const")
        .replacingOccurrences(of: "var", with: "let")
        .replacingOccurrences(of: "print", with: "console.log")
        .replacingOccurrences(of: "\"", with: "`")
        .replacingOccurrences(of: "nil", with: "null")
}

private func finalizePython(source: String) -> String {
    source
        .replacingOccurrences(of: "print(\"", with: "print(f\"")
        .replacingOccurrences(of: "else if", with: "elif")
        .replacingOccurrences(of: "true", with: "True")
        .replacingOccurrences(of: "false", with: "False")
}

private func finalizeKotlin(source: String) -> String {
    source
        .replacingOccurrences(of: "var", with: "var")
        .replacingOccurrences(of: "let", with: "val")
        .replacingOccurrences(of: "init", with: "constructor")
        .replacingOccurrences(of: "self", with: "this")
        .replacingOccurrences(of: "->", with: ":")
        .replacingOccurrences(of: "??", with: "?:")
        .replacingOccurrences(of: "func", with: "fun")
        .replacingOccurrences(of: "protocol", with: "interface")
        .replacingOccurrences(of: "nil", with: "null")
        .replacingOccurrences(of: "@objc", with: "")
        .replacingOccurrences(of: "@objcMembers", with: "")
        .replacingOccurrences(of: "AnyClass", with: "Any")
        .replacingOccurrences(of: "AnyClass", with: "Any")
}
