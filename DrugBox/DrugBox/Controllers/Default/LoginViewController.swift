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
import KeychainSwift
import Moya
import FirebaseMessaging

class LoginViewController: UIViewController{
    //MARK: - Outlet section
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var GoogleLoginButton: GIDSignInButton!
    
    // keychains
    static let keychain = KeychainSwift() // GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken
    
    // FCM Token
    var fcmToken: String?
    
    //MARK: - API provider
    let provider = MoyaProvider<LoginService>()
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GoogleLoginButton.colorScheme = .light
        GoogleLoginButton.style = .wide
        
        // FCM Token 발급
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
            } else if let token = token {
                print("FCM token: \(token)")
                self.fcmToken = token
                LoginViewController.keychain.set(token, forKey: "FCMToken")
            }
        }
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        PasswordTextField.textContentType = .oneTimeCode
        
    }
    
    //MARK: - Button Actions
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let email = EmailTextField.text, let password = PasswordTextField.text {
            callLogin(userData: assignLoginData(email: email, password: password)) { isSuccess in
                if isSuccess {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                } else {
                    print("로그인 정보가 없습니다.")
                }
            }
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
            let refreshtoken = result.user.refreshToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: accesstoken)
            
            // keychain에 tokens 저장
            LoginViewController.keychain.set(accesstoken, forKey: "GoogleAccessToken")
            LoginViewController.keychain.set(refreshtoken, forKey: "GoogleRefreshToken")
            
            // fcmToken을 포함하여 로그인 데이터 구성
            guard let fcmToken = self.fcmToken else {
                print("FCM token not available")
                return
            }
            let oauthData = self.assignGoogleLoginData(aToken: accesstoken, fcmToken: fcmToken, idToken: token)
    //        self.callGoogleLogin(with: oauthData) { isSuccess in
    //            if isSuccess {
    //                self.performSegue(withIdentifier: K.loginSegue, sender: self)
    //            }
    //        }
        }

    }
    
    //MARK: - API call Func
    // TODO : response null값 해결중
    private func callLogin(userData : UserLoginRequest, completion : @escaping (Bool) -> Void) {
        provider.request(.postLogin(param: userData)) { result in
            switch result {
            case .success(let response) :
                do {
//                    let responseData = try response.mapJSON()
                    let rData = try response.map(TokenDto.self)
//                    let responseData = try JSONDecoder().decode(TokenDto.self, from: response.data)
//                    print(rData)
                    LoginViewController.keychain.set(rData.accessToken, forKey: "serverAccessToken")
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
                completion(true)
            case .failure(let error) :
                print("Request failed : \(error)")
                completion(false)
            }
        }
    }
    
    private func assignLoginData(email: String, password: String) -> UserLoginRequest {
        return UserLoginRequest(email: email, password: password)
    }
    
    private func assignGoogleLoginData(aToken: String, fcmToken: String, idToken: String) -> OAuthLoginRequest {
        return OAuthLoginRequest(accessToken: aToken, fcmToken: fcmToken, idToken: idToken)
    }
    
    private func callGoogleLogin(completion : @escaping (Bool) -> Void) {
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.EmailTextField, self.EmailTextField.text != "" {
//            self.userEmail = self.EmailTextField.text
            self.PasswordTextField.becomeFirstResponder()
        } else if textField == self.PasswordTextField, self.PasswordTextField.text != ""{
//            self.userPW = self.PasswordTextField.text
            self.PasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    
}
