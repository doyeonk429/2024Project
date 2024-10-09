//
//  RegisterViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/22/24.
//

import UIKit
import Alamofire
import Toast
import Moya
import SnapKit
import Then

// 자세한 로그 보기
//let requestClosure = { (endpoint: Endpoint, closure: MoyaProvider<LoginService>.RequestResultClosure) in
//    do {
//        var request = try endpoint.urlRequest()
//        if let body = request.httpBody {
//            print("Request Body: \(String(data: body, encoding: .utf8) ?? "Cannot display body")")
//        }
//        closure(.success(request))
//    } catch {
//        closure(.failure(MoyaError.underlying(error, nil)))
//    }
//}

import UIKit
import Moya
import SnapKit
import Then

class RegisterViewController: UIViewController {
    
    //MARK: - UI Components
    private let emailTextField = UITextField().then {
        $0.placeholder = "Enter Email"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .emailAddress
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.returnKeyType = .next
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "Enter Password"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.textContentType = .oneTimeCode
        $0.returnKeyType = .done
    }
    
    private let completedButton = UIButton(type: .system).then {
        $0.setTitle("Sign Up", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(completedButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Variables
    let provider = MoyaProvider<LoginService>()
    var userEmail: String?
    var userPW: String?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupTextFieldDelegates()
    }
    
    //MARK: - Layout Setup with SnapKit
    private func setupLayout() {
        // 이메일 입력 필드
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        // 비밀번호 입력 필드
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(40)
        }
        
        // 완료 버튼
        view.addSubview(completedButton)
        completedButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Set TextField Delegates
    private func setupTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Actions
    @objc private func completedButtonPressed() {
        assignJoinData()
        postSignUp { [weak self] isSuccess in
            if isSuccess {
                self?.dismiss(animated: true)
            } else {
                print("회원 가입 실패")
            }
        }
    }
    
    //MARK: - Data Assignment
    private func assignJoinData() {
        userEmail = emailTextField.text
        userPW = passwordTextField.text
    }
    
    //MARK: - API Call
    private func postSignUp(completion: @escaping (Bool) -> Void) {
        if let emailString = userEmail, let pwString = userPW {
            let userRequest = UserLoginRequest(email: emailString, password: pwString)
            print(userRequest)
            provider.request(.postRegister(param: userRequest)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(IdResponse.self)
                        print("User Created: \(data)")
                        completion(true)
                    } catch {
                        print("Failed to map data : \(error)")
                        completion(false)
                    }
                case .failure(let error):
                    print("Request failed : \(error)")
                    completion(false)
                }
            }
        } else {
            print("User input이 없습니다")
            completion(false)
        }
    }
}

//MARK: - UITextFieldDelegate Methods
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 텍스트필드 내용 입력 후, return key 입력 시 다음 텍스트필드로 이동
        if textField == emailTextField, emailTextField.text != "" {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField, passwordTextField.text != "" {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
