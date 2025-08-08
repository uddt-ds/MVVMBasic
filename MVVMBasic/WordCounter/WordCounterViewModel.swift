//
//  WordCounterViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class WordCounterViewModel {

    var inputText: String? {
        didSet {
            updateCharacterCount()
        }
    }

    var outputText: String? {
        didSet {
            closureCount?()
        }
    }

    var closureCount: (() -> Void)?

    private func updateCharacterCount() {
        let count = inputText?.count
        outputText = "현재까지 \(count ?? 0)글자 작성중"
    }

}
