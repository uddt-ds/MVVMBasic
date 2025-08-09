//
//  OnboardingVC.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import UIKit
import SnapKit

final class OnboardingVC: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "WYT"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        transition()
        view.backgroundColor = .main

        configureHierarchy()
        configureLayout()
    }

    private func configureHierarchy() {
        [label].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func transition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let tabBarController = CustomTabBarController()
            self.setupNav()
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }

    private func setupNav() {
        navigationItem.backButtonTitle = ""
    }
}
