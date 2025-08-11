//
//  Observable.swift
//  MVVMBasic
//
//  Created by Lee on 8/11/25.
//

import Foundation

class Observable<T> {

    var action: ((T) -> Void)?

    var value: T {
        didSet {
            print("값이 바뀌었습니다", oldValue, value)
            action?(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.action = closure
    }
}
