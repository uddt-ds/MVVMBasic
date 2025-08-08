//
//  BMIViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

class BMIViewController: UIViewController {
    let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "키를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "몸무게를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    lazy var resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("클릭", for: .normal)
        setupCornerRadius(button)
        return button
    }()
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "여기에 결과를 보여주세요"
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()

        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }

    func configureHierarchy() {
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }

    func configureLayout() {
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        resultButton.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc func resultButtonTapped() {
        view.endEditing(true)

        let height = heightTextField.text
        let weight = weightTextField.text

        do {
            try inputChecker(height: height, weight: weight)
        } catch {
            resultLabel.text = BaseValidateError.invalidInput.rawValue
            return
        }

        if let heightText = height, let weightText = weight {
            do {
                let result: Double = try validate(height: heightText, weight: weightText)
                let resultString = String(format: "%.2f", result)
                var condition = ""

                switch result {
                case 0.0..<18.5: condition = "저체중"
                case 18.5..<23.0: condition = "정상체중"
                case 23.0..<25.0: condition = "과체중"
                case 25.0...: condition = "비만"
                default: return
                }

                resultLabel.text = "BMI 지수는 \(resultString), \(condition)입니다"
            } catch BaseValidateError.failConversionToValue {
                resultLabel.text = BaseValidateError.failConversionToValue.rawValue
            } catch BaseValidateError.invalidInput {
                resultLabel.text = BaseValidateError.invalidInput.rawValue
            } catch BaseValidateError.outOfRangeValue {
                resultLabel.text = BaseValidateError.outOfRangeValue.rawValue
            } catch BMIError.weightWrongInput {
                resultLabel.text = BMIError.weightWrongInput.rawValue
            } catch {
                print("Unknown Error")
                return
            }
        }
    }
}

extension BMIViewController {

    // 입력 자체가 유효한 입력인지
    private func inputChecker<T: StringProtocol>(height: T?, weight: T?) throws {
        guard let heightInput = height?.trimmingCharacters(in: .whitespaces), heightInput.count > 0,
              let weightInput = weight?.trimmingCharacters(in: .whitespaces), weightInput.count > 0 else {
            throw BaseValidateError.invalidInput
        }
    }

    // Double로 변환이 가능한지(결국 내부에서는 Double로 강제되었음)
    private func validate<T: BinaryFloatingPoint>(height: String, weight: String) throws -> T {
        var isInRange: Bool = false

        if let heightInput = Double(height), let weightInput = Double(weight) {

            do {
                let isRange = try checkRange(height: heightInput, weight: weightInput)
                isInRange = isRange
            } catch .outOfRangeValue {
                throw BaseValidateError.outOfRangeValue
            }

            if isInRange {
                if weightInput >= heightInput {
                    throw BMIError.weightWrongInput
                }

                let result = calculateBMINumber(height: heightInput, weight: weightInput)
                return T(result)
            } else {
                throw BaseValidateError.outOfRangeValue
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
            return false
        }

        if Double(weight) > maxWeight || Double(weight) < minWeight {
            return false
        }

        return true
    }

    private func calculateBMINumber<T: BinaryFloatingPoint>(height: T, weight: T) -> T {
        let multipleHeight = (height * 0.01) * (height * 0.01)
        return weight / multipleHeight
    }

}
