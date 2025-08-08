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
}
