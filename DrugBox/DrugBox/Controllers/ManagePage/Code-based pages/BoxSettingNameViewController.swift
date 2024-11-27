//
//  BoxSettingNameViewController.swift
//  DrugBox
//
//  Created by 김도연 on 9/5/24.
//

import UIKit
import SnapKit
import Then
import Moya
import SwiftyToaster

class BoxSettingNameViewController: UIViewController {
    public var drugboxId : Int?
    private var nameData = BoxNamePatch(drugboxId: 0, name: "")
    let provider = MoyaProvider<BoxManageService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    // UI 요소
    private let nameTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Enter new name"
    }
    
    private let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        saveButton.addTarget(self, action: #selector(saveName), for: .touchUpInside)
        setupUI()
    }
    
    // UI 설정 함수
    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        
        // SnapKit을 사용한 레이아웃 설정
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
    }
    
    // @objc 함수 - 저장 버튼을 눌렀을 때 실행될 함수
    @objc private func saveName() {
        guard let newName = nameTextField.text,
              !newName.isEmpty,
        let drugboxId = drugboxId else {
            print("값 부족")
            return
        }
        self.nameData = BoxNamePatch(drugboxId: drugboxId, name: newName)
//        print("New name: \(newName) for drugboxId: \(drugboxId)")
        
        // 이곳에 Moya를 사용한 API 호출을 추가하여 이름을 서버에 저장하는 로직을 구현할 수 있습니다.
        callPatchName(nameData: nameData) { isSuccess in
            if isSuccess {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("다시 시도해주세요")
            }
        }
    }
    
    private func callPatchName(nameData : BoxNamePatch, completion : @escaping (Bool) -> Void) {
        provider.request(.patchBoxName(id: nameData.drugboxId, name: nameData.name)) { result in
            switch result {
            case .success(let response) :
                if response.statusCode == 200 {
                    completion(true)
                } else {
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


