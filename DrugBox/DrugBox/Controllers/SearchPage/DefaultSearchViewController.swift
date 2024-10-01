//
//  DefaultSearchViewController.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit
import SnapKit
import Then
import MapKit
import CoreLocation
import Moya

class DefaultSearchViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    public var userLat = ""
    public var userLng = ""
    
    public var nearbyLocationList : [MapResponse] = []
    
    //    let provider = MoyaProvider<MapService>(plugins: [
    //        BearerTokenPlugin(),
    //        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    //    ])
    let provider = MoyaProvider<MapService>(plugins: [ BearerTokenPlugin()])
    
    // MARK: - UI Components
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "Search for places"
        $0.showsCancelButton = true
    }
    
    public let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupLayout()
        setupLocationManager()
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(mapView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 지도 설정: 확대, 스크롤, 회전 가능하도록 설정
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        //        // 줌 가능 여부
        //        mapView.isZoomEnabled = true
        //        // 이동 가능 여부
        //        mapView.isScrollEnabled = true
        //        // 각도 조절 가능 여부 (두 손가락으로 위/아래 슬라이드)
        //        mapView.isPitchEnabled = true
        //        // 회전 가능 여부
        //        mapView.isRotateEnabled = true
        //        // 나침판 표시 여부
        //        mapView.showsCompass = true
        //        // 축척 정보 표시 여부
        //        mapView.showsScale = true
        //        // 위치 사용 시 사용자의 현재 위치를 표시
        //        mapView.showsUserLocation = true
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        searchBar.delegate = self
    }
    
    // MARK: - Location Manager Setup
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check location authorization
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            print("Location services denied.")
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        userLocation = location.coordinate
        
        guard let userPosition = locations.first else { return }
        userLat = String(userPosition.coordinate.latitude)
        userLng = String(userPosition.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        fetchNearby { isSuccess in
            // 성공이면, 현재 지도에 마커 표시
            if isSuccess {
                print(self.nearbyLocationList.count)
                self.setVisibleAnnotations()
            } else {
                // 실패면, 실패 메시지
                print("주변 약국 위치 목록을 불러오는데 실패")
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Hide the keyboard
    }
    
    //MARK: - API functions
    private func setupParameters() -> LocationParameter {
        return LocationParameter(latitude: userLat, longitude: userLng)
    }
    
    private func fetchNearby(completion: @escaping (Bool) -> Void) {
        provider.request(.getMedicalLocations(loc: setupParameters())) { result in
            switch result {
            case .success(let response) :
                if response.statusCode == 200 {
                    do {
                        self.nearbyLocationList = try response.map([MapResponse].self)
                    }
                    catch {
                        print("Failed to decode response: \(error)")
                        completion(false)
                    }
                    completion(true)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

extension DefaultSearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        setVisibleAnnotations()  // 지도 영역이 변경될 때마다 호출
    }
    
    public func setVisibleAnnotations() {
        let visibleMapRect = mapView.visibleMapRect
        
        // 현재 보이는 영역 내의 위치만 필터링하여 annotation 생성
        let filteredLocations = nearbyLocationList.filter { location in
            if let lat = Double(location.latitude), let lng = Double(location.longitude) {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let mapPoint = MKMapPoint(coordinate)
                
                // 지도에서 보이는 영역에 해당 좌표가 포함되어 있는지 확인
                return visibleMapRect.contains(mapPoint)
            }
            return false
        }
        
        // 기존의 annotation 제거
        mapView.removeAnnotations(mapView.annotations)
        
        // 필터링된 위치에 annotation 추가
        filteredLocations.forEach { location in
            let annotation = MKPointAnnotation()
            if let lat = Double(location.latitude), let lng = Double(location.longitude) {
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                annotation.title = location.locationName
                annotation.subtitle = location.locationAddress
                // 지도에 annotation 추가
                mapView.addAnnotation(annotation)
            }
        }
    }
}

//// MARK: - SearchResultViewController
//
//class SearchResultViewController: UIViewController {
//
//    private let searchBar = UISearchBar().then {
//        $0.placeholder = "Search for places"
//        $0.showsCancelButton = true
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        setupLayout()
//    }
//
//    private func setupLayout() {
//        view.addSubview(searchBar)
//        searchBar.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(50)
//        }
//
//        searchBar.delegate = self
//    }
//}
//
//// MARK: - UISearchBarDelegate for SearchResultViewController
//
//extension SearchResultViewController: UISearchBarDelegate {
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Hide the keyboard
//    }
//}



