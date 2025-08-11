//
//  AgeObservable.swift
//  MVVMBasic
//
//  Created by Lee on 8/11/25.
//

import Foundation

class AgeObservable {

    var action: ((String) -> Void)?

    var text: String {
        didSet {
            print("글자가 바뀌었습니다", "oldValue", oldValue, text)
            action?(text)
        }
    }

    init(text: String) {
        self.text = text
        print("text값 초기화, Observable 인스턴스 생성")
    }

    func bind(closure: @escaping (String) -> Void) {
        closure(text)
        self.action = closure
    }

    func lazyBind(closure: @escaping (String) -> Void) {
        self.action = closure
    }
}
