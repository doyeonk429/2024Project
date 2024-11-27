//
//  AddNewBoxByCodeViewController.swift
//  DrugBox
//
//  Created by 김도연 on 11/18/24.
//

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class AddNewBoxByCodeViewController: UIViewController {
    
    let provider = MoyaProvider<BoxManageService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    // MARK: - UI Elements
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "초대코드를 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        return textField
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // User ID for API request
    private var userId: Int = 1 // 로그인 상태에서 정보 가져옴
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        codeTextField.delegate = self
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(codeTextField)
        view.addSubview(joinButton)
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func joinButtonPressed() {
        guard let code = codeTextField.text, !code.isEmpty else {
            codeTextField.placeholder = "초대코드를 입력해주세요"
            return
        }
        // Call the API asynchronously
        postInvitationCode(with: codeTextField.text!) { isSuccess in
            if isSuccess {
                let defaultBoxListVC = DrugBoxListVC()
                self.navigationController?.pushViewController(defaultBoxListVC, animated: true)
            } else {
                print("데이터 전송 실패")
            }
        }
    }
    
    // MARK: - API Call (Stub)
    private func postInvitationCode(with inviteCode: String, completion: @escaping (Bool) -> Void) {
        provider.request(.postJoinBox(inviteCode: inviteCode)) { result in
            switch result {
            case .success(let response) :
                do {
                    let responseData = try response.map(IdResponse.self)
//                    print("정상 Post된 box id : \(responseData.id)")
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("Failed to decode response: \(error)")
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
    

// MARK: - UITextFieldDelegate
extension AddNewBoxByCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        codeTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let code = codeTextField.text, !code.isEmpty else {
            codeTextField.placeholder = "코드를 입력해주세요."
            return
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if codeTextField.text?.isEmpty == false {
            return true
        } else {
            codeTextField.placeholder = "초대코드를 입력해주세요"
            return false
        }
    }
}
