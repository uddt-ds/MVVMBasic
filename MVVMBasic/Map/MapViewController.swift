//
//  MapViewController.swift
//  SeSAC7Week7
//
//  Created by Jack on 8/11/25.
//

import UIKit
import MapKit
import SnapKit

enum Category: String {
    case total = "전체"
    case korean = "한식"
    case overseas = "양식"
    case chinese = "중식"
}

class MapViewController: UIViewController {

    let totalData = RestaurantList.restaurantArray

    private lazy var seg: UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.insertSegment(withTitle: Category.total.rawValue, at: 0, animated: true)
        seg.insertSegment(withTitle: Category.korean.rawValue, at: 1, animated: true)
        seg.insertSegment(withTitle: Category.overseas.rawValue, at: 2, animated: true)
        seg.insertSegment(withTitle: Category.chinese.rawValue, at: 3, animated: true)
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = .black

        seg.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        seg.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        seg.addTarget(self, action: #selector(segValueChanged), for: .valueChanged)
        return seg
    }()

    private let mapView = MKMapView()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapView()
        addSeoulStationAnnotation()
        makeTotalAnnotation()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "지도"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "메뉴",
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
         
        [mapView, seg].forEach { view.addSubview($0) }

        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        seg.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
         
        let seoulStationCoordinate = CLLocationCoordinate2D(latitude: 37.5176, longitude: 126.8863)
        let region = MKCoordinateRegion(
            center: seoulStationCoordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func addSeoulStationAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.5547, longitude: 126.9706)
        annotation.title = "서울역"
        annotation.subtitle = "대한민국 서울특별시"
        mapView.addAnnotation(annotation)
    }

    private func makeTotalAnnotation() {
        for data in totalData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            annotation.title = data.name
            annotation.subtitle = data.address
            mapView.addAnnotation(annotation)
        }
    }

    private func makeCategoryAnnotation(_ categoryData: [Restaurant]) {
        for data in categoryData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            annotation.title = data.name
            annotation.subtitle = data.address
            mapView.addAnnotation(annotation)
        }
    }

    @objc private func rightBarButtonTapped() {
        let alertController = UIAlertController(
            title: "메뉴 선택",
            message: "원하는 옵션을 선택하세요",
            preferredStyle: .actionSheet
        )
        
        let alert1Action = UIAlertAction(title: "얼럿 1", style: .default) { _ in
            print("얼럿 1이 선택되었습니다.")
        }
        
        let alert2Action = UIAlertAction(title: "얼럿 2", style: .default) { _ in
            print("얼럿 2가 선택되었습니다.")
        }
        
        let alert3Action = UIAlertAction(title: "얼럿 3", style: .default) { _ in
            print("얼럿 3이 선택되었습니다.")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("취소가 선택되었습니다.")
        }
        
        alertController.addAction(alert1Action)
        alertController.addAction(alert2Action)
        alertController.addAction(alert3Action)
        alertController.addAction(cancelAction)
         
        present(alertController, animated: true, completion: nil)
    }

    private func filteredData(_ category: Category) -> [Restaurant] {
        return totalData.filter { $0.category == category.rawValue }
    }

    @objc private func segValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.removeAnnotations(mapView.annotations)
            makeTotalAnnotation()
        case 1:
            mapView.removeAnnotations(mapView.annotations)
            let data = filteredData(.korean)
            makeCategoryAnnotation(data)
        case 2:
            mapView.removeAnnotations(mapView.annotations)
            let data = filteredData(.overseas)
            makeCategoryAnnotation(data)
        case 3:
            mapView.removeAnnotations(mapView.annotations)
            let data = filteredData(.chinese)
            makeCategoryAnnotation(data)
        default:
            return
        }

    }
}
 
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        print("어노테이션이 선택되었습니다.")
        print("제목: \(annotation.title ?? "제목 없음")")
        print("부제목: \(annotation.subtitle ?? "부제목 없음")")
        print("좌표: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
        
        // 선택된 어노테이션으로 지도 중심 이동
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("어노테이션 선택이 해제되었습니다.")
    }
}
