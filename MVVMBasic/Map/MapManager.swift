//
//  MapManager.swift
//  MVVMBasic
//
//  Created by Lee on 8/13/25.
//

import Foundation
import MapKit

/*
 맵 매니저의 역할
 초기 위치 설정
 */

enum SavedLocation {
    case initial
    case company

    var coordinate: (lat: Double, lon: Double) {
        switch self {
        case .initial: return (37.5547, 126.9706)
        case .company: return (37.5176, 126.8863)
        }
    }
}

final class MapManager {

    static let shared = MapManager()

    private init() { }

    func setupMapView(location: SavedLocation) -> MKCoordinateRegion {

        let seoulStationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.lat, longitude: location.coordinate.lon)
        let region = MKCoordinateRegion(
            center: seoulStationCoordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )

        return region
    }

    func addAnnotation(lat: Double, lon: Double, title: String, subTitle: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = title
        annotation.subtitle = subTitle
        return annotation
    }

    func changeCameraPosition(annotation: MKAnnotation) -> MKCoordinateRegion {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        return region
    }
}
