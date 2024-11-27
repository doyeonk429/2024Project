//
//  LocationDetailviewController.swift
//  DrugBox
//
//  Created by 김도연 on 10/9/24.
//

import UIKit
import Moya
import SDWebImage
import SwiftyToaster

class LocationDetailviewController: UIViewController {
    
    // 장소 ID를 전달받아 API 호출에 사용
    var locationID: String?
    var locationName : String?
    var locationAddress : String?
    
    let provider = MoyaProvider<MapService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.text = self.locationName
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.text = self.locationAddress
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .gray
    }
    private let locationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .lightGray // 이미지가 없는 경우를 대비한 배경색
        $0.sd_imageIndicator = SDWebImageActivityIndicator.gray // 로딩 인디케이터 추가
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        
        if let id = locationID {
            fetchLocationDetail(locationID: id) { [weak self] locationDetail in
                guard let self = self else { return }
                // 이미지 로드
                if let imageURL = URL(string: locationDetail.locationPhotos) {
                    self.locationImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .highPriority) { image, error, _, _ in
                        if let error = error {
                            print("Failed to load image with SDWebImage: \(error.localizedDescription)")
                        } else {
                            print("Image loaded successfully.")
                        }
                    }
                }
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(locationImageView)
        view.addSubview(nameLabel)
        view.addSubview(addressLabel)
        
        locationImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(locationImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func fetchLocationDetail(locationID: String, completion: @escaping (MapDetailResponse) -> Void) {
        provider.request(.getLocationDetails(id: locationID)) { result in
            switch result {
            case .success(let response):
                do {
                    let locationDetail = try response.map(MapDetailResponse.self)
                    completion(locationDetail)
                } catch {
                    print("Failed to decode response: \(error)")
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                    print("Failed to load image from URL: \(url)")
                }
            }
        }
    }
}

