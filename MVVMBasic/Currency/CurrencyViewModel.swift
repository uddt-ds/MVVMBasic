//
//  CurrencyViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class CurrencyViewModel {

    var inputText: String? {
        didSet {
            print("Value Changed")
            validate()
        }
    }

    var outputText: String? {
        didSet {
            print("output Changed")
            outputClosure?()
        }
    }

    var outputClosure: (() -> Void)?

    func validate() {
        guard let amountText = inputText,
              let amount = Double(amountText) else {
            outputText = "올바른 금액을 입력해주세요"
            return
        }

        let exchangeRate = 1350.0 // 실제 환율 데이터로 대체 필요
        let convertedAmount = amount / exchangeRate
        outputText = String(format: "%.2f USD (약 $%.2f)", convertedAmount, convertedAmount)
    }
}
