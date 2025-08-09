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

extension UIViewController {

    func transition(style: TransitionMode) {
        switch style {
        case .essential:
            let tabBarController = UITabBarController()
            let ageVC = AgeViewController()
            ageVC.tabBarItem = UITabBarItem(title: "나이", image: UIImage(systemName: "person.fill"), tag: 0)
            let bmiVC = BMIViewController()
            bmiVC.tabBarItem = UITabBarItem(title: "BMI", image: UIImage(systemName: "waveform.path.ecg"), tag: 1)
            let birthDayVC = BirthDayViewController()
            birthDayVC.tabBarItem = UITabBarItem(title: "생년월일", image: UIImage(systemName: "calendar"), tag: 2)
            let currencyVC = CurrencyViewController()
            currencyVC.tabBarItem = UITabBarItem(title: "환율", image: UIImage(systemName: "wonsign.bank.building"), tag: 3)
            let wordCounterVC = WordCounterViewController()
            wordCounterVC.tabBarItem = UITabBarItem(title: "글자수", image: UIImage(systemName: "envelope.front"), tag: 4)
            tabBarController.viewControllers = [ageVC, bmiVC, birthDayVC, currencyVC, wordCounterVC]
            tabBarController.tabBar.tintColor = .systemBlue
            tabBarController.tabBar.unselectedItemTintColor = .systemGray
            view.window?.rootViewController = tabBarController
        case .option:
            let onBoardingVC = OnboardingVC()
            let nav = UINavigationController(rootViewController: onBoardingVC)
            view.window?.rootViewController = nav
        }
    }
}
