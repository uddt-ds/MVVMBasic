//
//  TransitionSelectViewController.swift
//  MVVMBasic
//
//  Created by Lee on 8/9/25.
//

import UIKit
import SnapKit

final class TransitionSelectViewController: UIViewController {

    private lazy var essentialButton: UIButton = {
        let button = UIButton()
        button.setTitle("Essential", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.tag = 0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Option", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }

    private func configureHierarchy() {
        [essentialButton, optionButton].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        essentialButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.width.equalTo(90)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }

        optionButton.snp.makeConstraints { make in
            make.top.equalTo(essentialButton.snp.bottom).offset(40)
            make.width.equalTo(90)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }

    private func configureView() {
        view.backgroundColor = .white
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            transition(style: .essential)
        case 1:
            transition(style: .option)
        default:
            return
        }
    }
}
