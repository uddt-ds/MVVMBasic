//
//  CurrencyViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class CurrencyViewModel {

    var inputText = Observable(value: "")

    init() {
        inputText.skipBind { _ in
            self.validate()
        }
    }

    var outputText = Observable(value: "")

    func validate() {
        let amountText = inputText.value
        guard let amount = Double(amountText) else {
            outputText.value = "올바른 금액을 입력해주세요"
            return
        }

        let exchangeRate = 1350.0 // 실제 환율 데이터로 대체 필요
        let convertedAmount = amount / exchangeRate
        outputText.value = String(format: "%.2f USD (약 $%.2f)", convertedAmount, convertedAmount)
    }
}
