//
//  ErrorObservable.swift
//  MVVMBasic
//
//  Created by Lee on 8/11/25.
//

import Foundation

class ErrorObservable {

    var action: ((Error) -> Void)?

    var error: Error? {
        didSet {
            print("에러가 생겼습니다")

            guard let error else { return }
            action?(error)
        }
    }

    init(error: Error) {
        self.error = error
    }

    func bind(closure: @escaping (Error) -> Void) {
        guard let error else { return }
        closure(error)
        self.action = closure
    }

    func lazyBind(closure: @escaping (Error) -> Void) {
        self.action = closure
    }
}
