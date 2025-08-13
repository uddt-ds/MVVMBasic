//
//  MapViewController.swift
//  SeSAC7Week7
//
//  Created by Jack on 8/11/25.
//

import UIKit
import MapKit
import SnapKit

enum Category: Int, CaseIterable {
    case total
    case korean
    case overseas
    case chinese

    var title: String {
        switch self {
        case .total: return "전체"
        case .korean: return "한식"
        case .overseas: return "양식"
        case .chinese: return "중식"
        }
    }
}

class MapViewController: UIViewController {

    let viewModel = MapViewModel()

    let categoryArr = Category.allCases

    private lazy var seg: UISegmentedControl = {

        let seg = UISegmentedControl()

        for num in 0..<4 {
            seg.insertSegment(withTitle: categoryArr[num].title, at: categoryArr[num].rawValue, animated: true)
        }

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

        viewModel.outputData.bind { datas in
            for data in datas {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
                annotation.title = data.name
                annotation.subtitle = data.address
                self.mapView.addAnnotation(annotation)
            }
        }
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

        let region = viewModel.mapManager.setupMapView(location: .company)

        mapView.setRegion(region, animated: true)
    }
    
    private func addSeoulStationAnnotation() {
        let annotation = viewModel.mapManager.addAnnotation(lat: 37.5547, lon: 126.9706, title: "서울역", subTitle: "대한민국 서울특별시")
        mapView.addAnnotation(annotation)
    }

    @objc private func rightBarButtonTapped() {
        let alertController = UIAlertController(
            title: "메뉴 선택",
            message: "원하는 옵션을 선택하세요",
            preferredStyle: .actionSheet
        )

        let map = self.mapView

        for num in 0..<4 {
            let alertAction = UIAlertAction(title: categoryArr[num].title, style: .default) { _ in
                map.removeAnnotations(map.annotations)
                self.viewModel.alertTapped.value = self.categoryArr[num]
            }
            alertController.addAction(alertAction)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("취소가 선택되었습니다.")
        }
        alertController.addAction(cancelAction)
         
        present(alertController, animated: true, completion: nil)
    }

    @objc private func segValueChanged(_ sender: UISegmentedControl) {
        mapView.removeAnnotations(mapView.annotations)
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.segmentTapped.value = .total
        case 1:
            viewModel.segmentTapped.value = .korean
        case 2:
            viewModel.segmentTapped.value = .overseas
        case 3:
            viewModel.segmentTapped.value = .chinese
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

        let region = viewModel.mapManager.changeCameraPosition(annotation: annotation)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("어노테이션 선택이 해제되었습니다.")
    }
}
