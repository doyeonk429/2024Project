//
//  LoginViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//  Modifed by doyeonk429 on 3/4/24.
import UIKit
import Firebase
import GoogleSignIn
import Alamofire

class LoginViewController: UIViewController {
    //MARK: - Outlet section
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var GoogleLoginButton: GIDSignInButton!
    
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GoogleLoginButton.colorScheme = .light
        GoogleLoginButton.style = .wide
    }
    //MARK: - Button Actions
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let email = EmailTextField.text, let password = PasswordTextField.text {
            postLogin(email: email, pw: password)
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
    }
    
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.registerSegue, sender: self)
    }
    
    
}
//MARK: - API section
extension LoginViewController {
    func postLogin(email: String, pw: String) {
        let url = "http://104.196.48.122:8080/auth/login/pw"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        // POST 로 보낼 정보
        let params = ["email": email, "password": pw] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("로그인 포스트 http body Error : \(error)")
        }
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공 \(response)")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8 토큰 처리하기
                    }
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
}

extension LoginViewController {
    @IBAction func googleLogin(_ sender: GIDSignInButton) {
            // 구글 인증
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
                guard error == nil else { return }
                
                // 인증을 해도 계정은 따로 등록을 해주어야 한다.
                // 구글 인증 토큰 받아서 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
                guard
                   let authentication = user?.authentication,
                   let idToken = authentication.idToken
                 else {
                   return
                 }
                 let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                accessToken: authentication.accessToken)
                
                // 사용자 정보 등록
                Auth.auth().signIn(with: credential) { _, _ in
                    // 로그인 화면으로 이동?
                }
              }
        }
}
