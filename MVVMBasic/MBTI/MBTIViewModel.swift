//
//  MBTIViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/13/25.
//

import Foundation

final class MBTIViewModel {

    var input: Input
    var output: Output

    private var selectedIndexDictionary: [Int:Int] = [:]
    private let buttonTitleArr = ButtonTitle.e.horizontalArray

    struct Input {
        let textFieldValue: Observable<String?> = Observable(value: nil)
        let textResult: Observable<String?> = Observable(value: nil)
        let selectedMBTI: Observable<Int?> = Observable(value: nil)
        let resultButtonTapped: Observable<Void> = Observable(value: ())
    }

    struct Output {
        let validateLabel: Observable<String> = Observable(value: "")
        let checkValidate: Observable<Bool> = Observable(value: false)
        let reloadIndex: Observable<[Int]> = Observable(value: [])
        let checkButtonState: Observable<Bool> = Observable(value: false)
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }

    private func transform() {
        input.textFieldValue.skipBind { text in
            self.checkUserInput(text)
        }

        input.textResult.skipBind { text in
            self.output.checkValidate.value = self.checkUserInput(text)
        }

        input.selectedMBTI.bind { tappedIndex in
            guard let tappedIndex else { return }
            let groupKey = self.buttonTitleArr[tappedIndex].groupKey
            let selectedIndex = self.selectedIndexDictionary[groupKey]
            if selectedIndex == nil {
                self.selectedIndexDictionary[groupKey] = tappedIndex
                self.output.reloadIndex.value = [tappedIndex]
            } else if selectedIndex == tappedIndex {
                self.selectedIndexDictionary[groupKey] = nil
                self.output.reloadIndex.value = [tappedIndex]
            } else {
                if let selectedIndex {
                    let reloadIndexs = [selectedIndex, tappedIndex]
                    self.selectedIndexDictionary[groupKey] = tappedIndex
                    self.output.reloadIndex.value = reloadIndexs
                }
            }

            // TODO: 이거 어떻게 합치지? tuple로 받아야 하나 checkButtonState를
            if self.selectedIndexDictionary.count == 4 {
                self.output.checkButtonState.value = true
            } else {
                self.output.checkButtonState.value = false
            }
        }

        input.resultButtonTapped.skipBind { _ in
            self.output.checkValidate.value = self.checkValidate()
        }
    }

    // TODO: 이 코드를 internal로 열어서 VC가 사용하는게 맞는지 고민해봐야함
    func buttonSelected(_ index: Int) -> Bool {
        let groupKey = self.buttonTitleArr[index].groupKey
        return selectedIndexDictionary[groupKey] == index
    }

    @discardableResult
    private func checkUserInput(_ text: String?) -> Bool {
        guard let text, text.count >= 2 && text.count < 10 else {
            output.validateLabel.value = "2글자 이상 10글자 미만을 입력해주세요"
            return false
        }

        let pattern = "[0-9]"

        if text.range(of: pattern, options: .regularExpression) != nil {
            output.validateLabel.value = "숫자는 입력할 수 없습니다"
            return false
        }

        let specialPattern = "[@#$%]"

        if text.range(of: specialPattern, options: .regularExpression) != nil {
            output.validateLabel.value = "@, #, $, % 특수문자는 입력이 불가능합니다"
            return false
        }

        output.validateLabel.value = ""
        return true
    }

    private func checkValidate() -> Bool {
        if selectedIndexDictionary.count == 4 && output.checkValidate.value {
            output.checkButtonState.value = true
            return true
        }
        output.checkButtonState.value = false
        return false
    }
}

