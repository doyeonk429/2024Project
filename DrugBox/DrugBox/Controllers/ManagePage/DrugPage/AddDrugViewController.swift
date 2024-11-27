//
//  AddDrugViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/13/24.
//

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class AddDrugViewController: UIViewController {
    
    public var drugName: String?
    public var drugboxId : Int?
    private var drugType : String?
    
    let provider = MoyaProvider<DrugService>(plugins: [BearerTokenPlugin()])
    
    let detailDrugView = AddNewDrugView()
    
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 등록하기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let drugNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 이름 :"
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let drugNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.ptdMediumFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let drugTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제형 선택"
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // Picker 관련 변수
    private let drugTypes = ["물약", "알약", "연고", "가루약", "파스", "처방약", "캡슐", "주사"]
    private var selectedDrugType: String = "물약" // 초기 선택 값

    // PickerView 생성
    private let typePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 10
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.lightGray.cgColor
        return picker
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("약 등록하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let drugname = drugName else {return}
        self.drugNameLabel.text = drugName
        
        setupUI()
        setupActions()

        // PickerView 설정
        typePickerView.delegate = self
        typePickerView.dataSource = self
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(drugNameTitleLabel)
        view.addSubview(drugNameLabel)
        
        view.addSubview(drugTypeTitleLabel)
        view.addSubview(typePickerView) // PickerView 추가
        
        view.addSubview(detailDrugView)
        view.addSubview(registerButton)
        
        // Set constraints for title label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Set constraints for drugNameTitleLabel and drugNameLabel
        drugNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        drugNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(drugNameTitleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(drugNameTitleLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }

        drugTypeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(drugNameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        // PickerView 레이아웃
        typePickerView.snp.makeConstraints { make in
            make.top.equalTo(drugTypeTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        detailDrugView.snp.makeConstraints { make in
            make.top.equalTo(typePickerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(200)
        }
        
        // Set constraints for register button
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func registerButtonTapped() {
        if let userData = setupRequestData() {
            callPostApi(data: userData) { isSuccess in
                if isSuccess {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("다시 시도하세요.")
                }
            }
        } else {
            print("데이터 안만들어짐.")
        }
    }
    
    private func setupRequestData() -> DrugSaveRequest? {
        if let count = detailDrugView.countValue,
           let dateString = detailDrugView.dateValue,
           let location = detailDrugView.returnLocation(),
           let boxId = self.drugboxId,
           let name = self.drugName
        {
            let detailData = DrugDetailSaveRequest(count: count, expDate: dateString, location: location)
            
            return DrugSaveRequest(detail: [detailData], drugboxId: boxId, name: name, type: self.drugType ?? drugTypes[0])
        } else {
            print(detailDrugView.countValue ?? "count 문제")
            print(detailDrugView.dateValue ?? "date 문제")
            print(detailDrugView.returnLocation() ?? "location 문제")
            print(self.drugboxId ?? "id 문제")
            print(self.drugName ?? "name 문제")
        }
        return nil
    }
    
    private func callPostApi(data: DrugSaveRequest, completion : @escaping (Bool) -> Void) {
        print(data)
        provider.request(.postDrugs(data: data)) { result in
            switch result {
            case .success(let response) :
                do {
                    _ = try response.map([IdResponse].self)
                    completion(true)
                } catch {
                    print("map data error : \(error)")
                    completion(false)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

extension AddDrugViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // PickerView에 표시할 열(row) 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 하나의 열
    }
 
    // PickerView에 표시할 행(row) 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drugTypes.count
    }

    // PickerView의 각 행에 표시할 데이터
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drugTypes[row]
    }

    // PickerView에서 선택했을 때 호출
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDrugType = drugTypes[row]
        self.drugType = drugTypes[row]
    }
}

