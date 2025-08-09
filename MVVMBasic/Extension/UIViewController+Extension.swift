//
//  UIViewController+Extension.swift
//  MVVMBasic
//
//  Created by Lee on 8/7/25.
//

import UIKit

extension UIViewController {

    func setupCornerRadius<T: UIView>(_ view: T) {
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
