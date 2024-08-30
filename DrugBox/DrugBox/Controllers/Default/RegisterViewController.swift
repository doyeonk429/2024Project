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

class RegisterViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    //MARK: - Variables
//    let provider = MoyaProvider<LoginService>(requestClosure: requestClosure)
    let provider = MoyaProvider<LoginService>()
    var userEmail : String?
    var userPW : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        PasswordTextField.textContentType = .oneTimeCode
    }
    
    //MARK: - Actions
    @IBAction func CompletedButtonPressed(_ sender: UIButton) {
        assignJoinData()
        postSignUp { [weak self] isSuccess in
            if isSuccess {
                self?.dismiss(animated: true)
            } else {
                print("회원 가입 실패")
            }
        }
    }
    
    private func assignJoinData() {
        userEmail = self.EmailTextField.text
        userPW = self.PasswordTextField.text
    }
    
    private func postSignUp(completion: @escaping (Bool) -> Void) {
        if let emailString = userEmail, let pwString = userPW {
            let userRequest = UserLoginRequest(email: emailString, password: pwString)
            print(userRequest)
            provider.request(.postRegister(param: userRequest)) { result in
                switch result {
                case .success(let response) :
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

//MARK: - TextField Delegate Fuctions
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 텍스트필드 내용 입력 후, return key 입력 시 다음 텍스트필드로 이동
        if textField == self.EmailTextField, self.EmailTextField.text != "" {
            self.userEmail = self.EmailTextField.text
            self.PasswordTextField.becomeFirstResponder()
        } else if textField == self.PasswordTextField, self.PasswordTextField.text != ""{
            self.userPW = self.PasswordTextField.text
            self.PasswordTextField.resignFirstResponder()
        }
        return true
    }
}
