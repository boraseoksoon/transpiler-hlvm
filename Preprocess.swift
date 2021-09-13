//
//  Preprocess.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/09/13.
//

import Foundation

public func preprocess(source: String, for language: Language) -> String {
    // WARN: Code generation based on AST will not work properly if syntax is replaced ahead of time
    switch language {
        case .kotlin:
        return source
        case .python:
            return source
        default:
            return source
    }
}
