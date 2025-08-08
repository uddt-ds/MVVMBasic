//
//  DateManager.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import Foundation

struct DateManager {
    static let shared = DateManager()

    let formatter = DateFormatter()

    private init() {
        self.formatter.locale = Locale(identifier: "ko_KR")
        self.formatter.dateFormat = "yyyyMMdd"
    }
}
