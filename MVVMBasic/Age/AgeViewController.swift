//
//  AgeViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

final class AgeViewController: UIViewController {

    private let viewModel = AgeViewModel()

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
        label.text = ""
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()

        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)

        viewModel.outputText.lazyBind { text in
            self.label.text = text
        }

        viewModel.closureError.lazyBind { error in
            guard let error = error as? BaseValidateError else { return }
            DispatchQueue.main.async {
                self.showAlert(title: "경고", message: error.rawValue)
            }
        }
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

        viewModel.inputText.text = text
    }
}
