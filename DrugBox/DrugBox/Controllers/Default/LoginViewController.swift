//
//  LoginViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//  Modifed by doyeonk429 on 3/4/24.
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Alamofire


class LoginViewController: UIViewController{
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
            DispatchQueue.main.async {
                self.postLogin(email: email, pw: password)
                
            }
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.registerSegue, sender: self)
    }
    
    @IBAction func googleLogin(_ sender: GIDSignInButton) {
        // 구글 인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
          let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
            guard let self,
                  let result = signInResult,
                  let token = result.user.idToken?.tokenString else { return }
            
            let accesstoken = result.user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: accesstoken)
        }
    }
        
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let config = GIDConfiguration.init(clientID: clientID)
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//            guard error == nil else {
//                // login failure
//                let popup = UIAlertController(title: "로그인 실패", message: "다시 로그인 해주세요", preferredStyle: .alert)
//                let action = UIAlertAction(title: "확인", style: .default)
//                popup.addAction(action)
//                self.present(popup, animated: true)
//                return
//            }
//            // success
//            guard
//                let idToken = signInResult?.user.idToken,
//                let accessToken = signInResult?.user.accessToken
//            else {
//                return
//            }
////            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//        }
        
}
    

    
//MARK: - API section
extension LoginViewController {
    func postLogin(email: String, pw: String) {
        let url = K.apiURL.loginURL
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
