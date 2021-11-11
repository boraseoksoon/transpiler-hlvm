//
//  async.swift
//  hlvm
//
//  Created by Seoksoon Jang on 2021/11/11.
//

import Foundation

func asyncTranspile(_ source: String) async -> String {
    return await withUnsafeContinuation { continuation in
        DispatchQueue.global().async {
            continuation.resume(returning: transpile(HLVM_IR))
        }
    }
}

func `async`(code: @escaping () async -> Void) {
    Task {
        await code()
    }
}
