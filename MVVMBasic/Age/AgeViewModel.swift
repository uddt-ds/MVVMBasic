//
//  AgeViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class AgeViewModel {

    var inputText: String? {
        didSet {
            print("input 값이 변경되었습니다")
            // 애초에 Input Text는 viewModel에서 검증할때만 쓰는건데
            // 여기서 에러를 상위로 던지면, VC에서 캐치할 수가 있나?
            checkValidate()
        }
    }

    var outputText: String? {
        didSet {
            print("output 값이 변경되었습니다")
            closureText?()
        }
    }

    var closureText: (() -> Void)?


    //VC에서 값 전달한 다음에 VC에서 VM의 메서드를 사용할 수 있지 않을까
    func checkValidate() {
        guard let text = inputText else { return }
        do {
            let result = try checkValidateInput(input: text)
            outputText = "당신은 \(result)살입니다"
        } catch .failConversionToValue {
            outputText = BaseValidateError.failConversionToValue.rawValue
        } catch .invalidInput {
            outputText = BaseValidateError.invalidInput.rawValue
        } catch {
            outputText = BaseValidateError.outOfRangeValue.rawValue
        }
    }

    func checkValidateInput<T: StringProtocol>(input: T) throws(BaseValidateError) -> Int {

        let minNum = RangeData.age.rangeNum.min
        let maxNum = RangeData.age.rangeNum.max

        // input이 공백을 포함하고 있는지
        if input.contains(where: { $0.isWhitespace }) {
            throw .invalidInput
        }

        // Input이 Int로 변환이 가능한지
        guard let intInput = Int(input) else {
            throw .failConversionToValue
        }

        // 유효한 범위인지
        guard minNum <= intInput && maxNum >= intInput else {
            throw .outOfRangeValue
        }

        return intInput
    }
}
