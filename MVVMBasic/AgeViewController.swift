//
//  AgeViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

final class AgeViewController: UIViewController {
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "나이를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle( "클릭", for: .normal)
        setupCornerRadius(button)
        return button
    }()
    private let label: UILabel = {
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
    
    private func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(resultButton)
        view.addSubview(label)
    }
    
    private func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func resultButtonTapped() {
        view.endEditing(true)

        guard let text = textField.text else { return }
        do {
            let result = try checkValidateInput(input: text)
            label.text = "당신은 \(result)살 입니다"
        } catch .failConversionToValue {
            label.text = BaseValidateError.failConversionToValue.rawValue
        } catch .invalidInput {
            label.text = BaseValidateError.invalidInput.rawValue
        } catch {
            label.text = BaseValidateError.outOfRangeValue.rawValue
        }
    }
}

extension AgeViewController {
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
        guard minNum < intInput && maxNum > intInput else {
            throw .outOfRangeValue
        }

        return intInput
    }
}

// Numeric으로 해도 Int로 바꿀 수가 없음 ㅠㅠ
//extension AgeViewController {
//    @discardableResult
//    private func checkValidateInput<T: Numeric>(input: T) throws -> Bool {
//        if let userInput: Int = Int(input) {
//
//        }
//    }
//}
