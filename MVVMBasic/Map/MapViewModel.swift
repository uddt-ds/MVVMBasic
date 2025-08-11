//
//  MapViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/11/25.
//

import Foundation

class MapViewModel {

    var segmentTapped = Observable(value: Category.total)

    var outputData = Observable<[Restaurant]>(value: [])

    init() {
        segmentTapped.bind { category in
            self.outputData.value = self.getFilteredData(category)
        }
    }

    let totalData = RestaurantList.restaurantArray

    func getFilteredData(_ category: Category) -> [Restaurant] {
        switch category {
        case .total: return totalData
        case .korean, .overseas, .chinese:  return totalData.filter { $0.category == category.rawValue }
        }
    }
}
