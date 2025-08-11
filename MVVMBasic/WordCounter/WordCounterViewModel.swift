//
//  WordCounterViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class WordCounterViewModel {

//    var inputText: String? {
//        didSet {
//            updateCharacterCount()
//        }
//    }

    var inputText = Observable(value: "")

    init() {
        inputText.bind { _ in
            self.updateCharacterCount()
        }
    }


    var outputText = Observable(value: "")
//
//    var outputText: String? {
//        didSet {
//            closureCount?()
//        }
//    }

    private func updateCharacterCount() {
        let count = inputText.value.count
        outputText.value = "현재까지 \(count)글자 작성중"
    }

}
