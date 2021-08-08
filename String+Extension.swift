//
//  String+Extension.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation

extension String {
    func trim(for language: Language) -> String {
//        self
        self
            // .eraseLanguageDecorator()
            .eraseType()
            .replaceDataStructure(for: language)
            .replaceCommentStyle(for: language)
    }
    
    private func replaceDataStructure(for language: Language) -> String {
        switch language {
            case .python:
                return self.replacingOccurrences(of: "[:]", with: "{}")
            default:
                return self
        }
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

