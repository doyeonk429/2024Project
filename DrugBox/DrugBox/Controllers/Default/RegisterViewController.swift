//
//  RegisterViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/22/24.
//

import UIKit
import Alamofire
import Toast

class RegisterViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    //MARK: - Variables
    var userEmail : String?
    var userPW : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        PasswordTextField.textContentType = .newPassword
    }
    
    //MARK: - Actions
    @IBAction func CompletedButtonPressed(_ sender: UIButton) {
        // post request 날리기
        if let email = userEmail, let pw = userPW {
            DispatchQueue.main.async {
                self.PostUserRegisterAPI(email: email, pw: pw)
            }
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

extension RegisterViewController {
    func PostUserRegisterAPI(email userEmail: String, pw userPassword: String) -> Void {
        let url = K.apiURL.registerURL
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60
        // POST 로 보낼 정보
        let params = ["email": userEmail, "password": userPassword] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("등록 포스트 http body Error : \(error)")
        }
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공 \(response)")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                    self.view.makeToast("가입 완료!", duration: 2.0, position: .center)
                    self.dismiss(animated: true)
                    }
            case .failure(let error):
                print("error : \(error.errorDescription!)")
//                self.view.makeToast("가입 실패", duration: 2.0, position: .center)
            }
        }
    }
}
