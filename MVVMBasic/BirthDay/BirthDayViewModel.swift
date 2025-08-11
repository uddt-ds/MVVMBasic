//
//  BirthDayViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

class BirthDayViewModel {

    var inputYear = Observable(value: "")
    var inputMonth = Observable(value: "")
    var inputDay = Observable(value: "")

    var buttonTapped = Observable(value: ())

    var outputText = Observable(value: "")

    init() {
        buttonTapped.skipBind { _ in
            self.checkValidate()
        }
    }

    private func checkValidate() {
        let year = inputYear.value
        let month = inputMonth.value
        let day = inputDay.value

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

            outputText.value = "태어난 날짜로부터 D+\(count.day ?? 0)일 입니다"

        } catch BaseValidateError.invalidInput {
            outputText.value = BaseValidateError.invalidInput.rawValue
        } catch BaseValidateError.outOfRangeValue {
            outputText.value = BaseValidateError.outOfRangeValue.rawValue
        } catch {
            print("Unknown Error")
        }
    }

    // 입력 자체가 유효한지 확인
    private func inputChecker<T: StringProtocol>(year: T, month: T, day: T) throws -> (Int, Int, Int) {
        let y = year.trimmingCharacters(in: .whitespaces)
        let m = month.trimmingCharacters(in: .whitespaces)
        let d = day.trimmingCharacters(in: .whitespaces)
        guard let intYear = Int(y),
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

}
