//
//  ValidateError.swift
//  MVVMBasic
//
//  Created by Lee on 8/7/25.
//

import Foundation

enum BaseValidateError: String, Error {
    case outOfRangeValue = "범위를 초과했습니다"
    case invalidInput = "잘못된 입력입니다. 다시 입력해주세요"
    case failConversionToValue = "입력에 문자열을 포함할 수 없습니다"
}


