//
//  String+Extension.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/08/02.
//

import Foundation

//extension String {
//    func trimSource(for language: Language) -> String {
//        self
//            .eraseType(for: language)
//            .replaceDataStructure(for: language)
//            .replaceCommentStyle(for: language)
//    }
//
//    private func replaceDataStructure(for language: Language) -> String {
//        switch language {
//            case .python:
//                return self.replacingOccurrences(of: "[:]", with: "{}")
//            default:
//                return self
//        }
//    }
//
//    private func eraseType(for language: Language) -> String {
//        switch language {
//            case .python:
//                return self
////                    .replacingOccurrences(of: ": *?\\[.*?\\]",
////                                          with: "$1",
////                                          options: [.regularExpression])
////                    .replacingOccurrences(of: ": *?\\[(.*?)\\]+",
////                                          with: "$1",
////                                          options: [.regularExpression])
////                    .replacingOccurrences(of: ": *?[a-zA-Z0-9]+\\<(.*?)\\>",
////                                          with: "$1",
////                                          options: [.regularExpression])
////                    .replacingOccurrences(of: ":.*?[[]+[[a-zA-Z0-9]+][?]?",
////                                          with: "$1",
////                                          options: [.regularExpression])
//            default:
//                return self
//        }
//
//        // \[(.*?)\]|\<(.*?)\>|[a-zA-Z0-9]+\<(.*?)\>|:.[a-zA-Z0-9]+
//
//        // dictionary =>
//        // :.*?\<(.*?)\> => X
//        // :.*?\[(.*?)\]+
//
//        //generic =>
//        // :.*?[a-zA-Z0-9]+\<(.*?)\>
//
//        //array =>
//        // : *?\[(.*?)\]
//        // => better => :.*?[[]+[[a-zA-Z0-9]+]
//
//        //need to check
//        //:.*?\[(.*?)\]
//    }
//
//    private func replaceCommentStyle(for language: Language) -> String {
//        switch language {
//            case .python:
//                return self
//                    .replacingOccurrences(of: "/**", with: "'''")
//                    .replacingOccurrences(of: "/*", with: "'''")
//                    .replacingOccurrences(of: "*/", with: "'''")
//                    .replacingOccurrences(of: "///", with: "#")
//                    .replacingOccurrences(of: "//", with: "#")
//            default:
//                return self
//        }
//    }
//}
//
