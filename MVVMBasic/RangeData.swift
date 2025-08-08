//
//  RangeData.swift
//  MVVMBasic
//
//  Created by Lee on 8/7/25.
//

import Foundation

enum RangeData {
    case age
    case weight
    case height
    case year
    case month
    case day

    //이 문법은 불가능. 연산 프로퍼티에는 제네릭 타입을 사용할 수 없음
//    var range<T: Numeric>: T {
//        switch self {
//        case .age: return Range(1...100)
//        }
//    }

    var rangeNum: (min: Int, max: Int) {
        switch self {
        case .age: return (1, 100)
        case .weight: return (10, 150)
        case .height: return (60, 200)
        case .year: return (1920, 2025)
        case .month: return (1, 12)
        case .day: return (1, 31)
        }
    }
}

/*
 태양력 : 지구가 태양 주위를 한 바퀴 도는 시간을 기준으로 만들어짐
 지구가 태양 주위를 한 바퀴 도는데 걸리는 시간이 365.24일 이니까
 0.24일을 보정하기 위해서 윤달을 지정
 윤달 : 4년마다 하루(2월 29일)를 추가하여 보정

 1, 3, 5, 7, 8, 10, 12월 : 31일
 4, 6, 9 , 11월: 30일
 2월 : 28일 / 또는 4년마다 1번 29일
 */

