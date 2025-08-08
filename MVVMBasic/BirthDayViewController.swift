//
//  BirthDayViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

class BirthDayViewController: UIViewController {
    let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "년도를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        return label
    }()
    let monthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "월을 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        return label
    }()
    let dayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "일을 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        return label
    }()
    lazy var resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle( "클릭", for: .normal)
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
        view.addSubview(yearTextField)
        view.addSubview(yearLabel)
        view.addSubview(monthTextField)
        view.addSubview(monthLabel)
        view.addSubview(dayTextField)
        view.addSubview(dayLabel)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        yearTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField)
            make.leading.equalTo(yearTextField.snp.trailing).offset(12)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(monthTextField)
            make.leading.equalTo(monthTextField.snp.trailing).offset(12)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(monthTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayTextField)
            make.leading.equalTo(dayTextField.snp.trailing).offset(12)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(20)
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

        let year = yearTextField.text
        let month = monthTextField.text
        let day = dayTextField.text

        do {
            let input = try inputChecker(year: year, month: month, day: day)
            let (intYear, intMonth, intDay) = input

            let rawDate = try validateBirthday(year: intYear, month: intMonth, day: intDay)
            let (yearComponent, monthComponent, dayComponent) = rawDate

            let zeroWithMonth = String(format: "%02d", monthComponent)
            let zeroWithDay = String(format: "%02d", dayComponent)

            guard let date = DateManager.shared.formatter.date(from: "\(yearComponent)\(zeroWithMonth)\(zeroWithDay)") else {
                return
            }

            let count = Calendar.current.dateComponents([.day], from: date, to: .now)

            resultLabel.text = "태어난 날짜로부터 D+\(count.day ?? 0)일 입니다"

        } catch BaseValidateError.invalidInput {
            resultLabel.text = BaseValidateError.invalidInput.rawValue
        } catch BaseValidateError.outOfRangeValue {
            resultLabel.text = BaseValidateError.outOfRangeValue.rawValue
        } catch {
            print("Unknown Error")
        }
    }
}

extension BirthDayViewController {

    // 입력 자체가 유효한지 확인
    private func inputChecker<T: StringProtocol>(year: T?, month: T?, day: T?) throws -> (Int, Int, Int) {
        guard let y = year?.trimmingCharacters(in: .whitespaces),
              let m = month?.trimmingCharacters(in: .whitespaces),
              let d = day?.trimmingCharacters(in: .whitespaces),
              let intYear = Int(y),
              let intMonth = Int(m),
              let intDay = Int(d) else {
            throw BaseValidateError.invalidInput
        }

        return (intYear, intMonth, intDay)
    }

    // 범위가 유효한지 확인
    private func validateBirthday(year: Int, month: Int, day: Int) throws -> (Int, Int, Int) {
        let yearRange = RangeData.year.rangeNum.min...RangeData.year.rangeNum.max
        let monthRange = RangeData.month.rangeNum.min...RangeData.month.rangeNum.max
        let maxDay = maxDay(month: month)
        let dayRange = RangeData.day.rangeNum.min...min(maxDay, RangeData.day.rangeNum.max)

        guard yearRange.contains(year),
              monthRange.contains(month),
              dayRange.contains(day) else {
            throw BaseValidateError.outOfRangeValue
        }

        return (year, month, day)
    }

    // 최대 날짜 확인
    private func maxDay(month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return 28
        default:
            return 0
        }
    }

    // TODO: 윤달 검사 추가 필요


//    private func validateBirthday<T: Comparable & Numeric>(year: T, month: T, day: T) throws {
//        let yearRange = RangeData.year.rangeNum.0...RangeData.year.rangeNum.1
//        let monthRange = RangeData.month.rangeNum.0...RangeData.month.rangeNum.1
//        let dayRange = RangeData.day.rangeNum.0...RangeData.day.rangeNum.1
//        guard yearRange.contains(year),
//              monthRange.contains(month),
//              dayRange.contains(day) else {
//
//        }
//    }
}
