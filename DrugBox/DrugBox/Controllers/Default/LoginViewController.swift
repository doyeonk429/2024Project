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

class LoginViewController: UIViewController{
    //MARK: - Outlet section
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var GoogleLoginButton: GIDSignInButton!
    
    // keychains
    static let keychain = KeychainSwift() // GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken
    
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
//                self.postLogin(email: email, pw: password)
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
            let refreshtoken = result.user.refreshToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: accesstoken)
            
            // keychain에 tokens 저장
            LoginViewController.keychain.set(accesstoken, forKey: "GoogleAccessToken")
            LoginViewController.keychain.set(refreshtoken, forKey: "GoogleRefreshToken")
        }
        // call moya api
        
    }
}
