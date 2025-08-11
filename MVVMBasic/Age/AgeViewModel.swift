//
//  AgeViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class AgeViewModel {

    var inputText = AgeObservable(text: "")
    var outputText = AgeObservable(text: "")

    var closureError = ErrorObservable(error: BaseValidateError.invalidInput)
    init() {
        print("AgeViewModel Init")
        inputText.bind { _ in
            do {
                try self.checkValidate()
            } catch {
                self.closureError.error = error
            }
        }
    }


    //VC에서 값 전달한 다음에 VC에서 VM의 메서드를 사용할 수 있지 않을까
    // 에러 핸들링을 어디서 할건지
    func checkValidate() throws(BaseValidateError) {
        print("실행")
        let text = inputText.text
        do {
            let result = try checkValidateInput(input: text)
            outputText.text = "당신은 \(result)살입니다"
        } catch .failConversionToValue {
            print("fail 캐치")
            throw .failConversionToValue
        } catch .invalidInput {
            print("invalid 캐치")
            throw .invalidInput
        } catch {
            print("outOfRange 캐치")
            throw .outOfRangeValue
        }
    }

    func checkValidateInput<T: StringProtocol>(input: T) throws(BaseValidateError) -> Int {

        let minNum = RangeData.age.rangeNum.min
        let maxNum = RangeData.age.rangeNum.max

        // input이 공백을 포함하고 있는지
        if input.contains(where: { $0.isWhitespace }) || input.count == 0 {
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
