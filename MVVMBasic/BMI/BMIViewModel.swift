//
//  BMIViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class BMIViewModel {

    var inputHeight = Observable(value: "")

    var inputWeight = Observable(value: "")

    init() {
        buttonTapped.skipBind { _ in
            self.validate()
        }
    }

    var buttonTapped = Observable(value: ())

    var outputText = Observable(value: "")

    var bmiError: Observable<BMIError?> = Observable(value: nil)

    func validate() {
        let height = inputHeight.value
        let weight = inputWeight.value

        do {
            try inputChecker(height: height, weight: weight)
        } catch {
            outputText.value = BaseValidateError.invalidInput.rawValue
            return
        }

        let heightText = height
        let weightText = weight
        do {
            let result: Double = try validateCheck(height: heightText, weight: weightText)
            let resultString = String(format: "%.2f", result)
            var condition = ""

            switch result {
            case 0.0..<18.5: condition = "저체중"
            case 18.5..<23.0: condition = "정상체중"
            case 23.0..<25.0: condition = "과체중"
            case 25.0...: condition = "비만"
            default: return
            }

            outputText.value = "BMI 지수는 \(resultString), \(condition)입니다"
        } catch BaseValidateError.failConversionToValue {
            outputText.value = BaseValidateError.failConversionToValue.rawValue
        } catch BaseValidateError.invalidInput {
            outputText.value = BaseValidateError.invalidInput.rawValue
        } catch BaseValidateError.outOfRangeValue {
            outputText.value = BaseValidateError.outOfRangeValue.rawValue
        } catch BMIError.weightWrongInput {
            outputText.value = ""
            bmiError.value = BMIError.weightWrongInput
        } catch {
            print("Unknown Error")
            return
        }
    }

    // 입력 자체가 유효한 입력인지
    private func inputChecker<T: StringProtocol>(height: T?, weight: T?) throws {
        guard let heightInput = height?.trimmingCharacters(in: .whitespaces), heightInput.count > 0,
              let weightInput = weight?.trimmingCharacters(in: .whitespaces), weightInput.count > 0 else {
            throw BaseValidateError.invalidInput
        }
    }

    // Double로 변환이 가능한지(결국 내부에서는 Double로 강제되었음)
    private func validateCheck<T: BinaryFloatingPoint>(height: String, weight: String) throws -> T {
        var isInRange: Bool = false

        if let heightInput = Double(height), let weightInput = Double(weight) {
            do {
                let isRange = try checkRange(height: heightInput, weight: weightInput)
                isInRange = isRange
            } catch .outOfRangeValue {
                isInRange = false
                throw BaseValidateError.outOfRangeValue
            }

            if isInRange {
                if weightInput >= heightInput {
                    throw BMIError.weightWrongInput
                }

                let result = calculateBMINumber(height: heightInput, weight: weightInput)
                return T(result)
            }
        }

        throw BaseValidateError.failConversionToValue
    }

    // 범위 체크
    private func checkRange<T: BinaryFloatingPoint>(height: T, weight: T) throws(BaseValidateError) -> Bool {
        let minHeight = Double(RangeData.height.rangeNum.min)
        let maxHeight = Double(RangeData.height.rangeNum.max)
        let minWeight = Double(RangeData.weight.rangeNum.min)
        let maxWeight = Double(RangeData.weight.rangeNum.max)

        if Double(height) > maxHeight || Double(height) < minHeight {
            throw .outOfRangeValue
        }

        if Double(weight) > maxWeight || Double(weight) < minWeight {
            throw .outOfRangeValue
        }

        return true
    }

    private func calculateBMINumber<T: BinaryFloatingPoint>(height: T, weight: T) -> T {
        let multipleHeight = (height * 0.01) * (height * 0.01)
        return weight / multipleHeight
    }
}
