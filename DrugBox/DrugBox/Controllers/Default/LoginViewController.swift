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
import SnapKit

class LoginViewController: UIViewController {
    
    // Keychains
    static let keychain = KeychainSwift() // For storing tokens like GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken
    
    // FCM Token
    var fcmToken: String?
    
    // API provider
    let provider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin()])
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "DrugBox"
        label.font = UIFont.roRegularFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = UIColor(named: "AppGreen")
        return label
    }()
    // Creating the titleLabel with an icon in the text
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//            label.textAlignment = .center
//            label.textColor = .green
//            label.font = UIFont.boldSystemFont(ofSize: 30)
//
//        // Create an attachment with the icon image
//        let imageAttachment = NSTextAttachment()
//        imageAttachment.image = UIImage(systemName: "cross.case.circle.fill") // Use an SF Symbol or custom image
//        
//        // Adjust the image size to fit the label's text size
//        let imageOffsetY: CGFloat = -6.0 // Adjust the offset to align with the larger text size
//            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 24, height: 24)
//        
//        // Create attributed string with the image
//        let attachmentString = NSAttributedString(attachment: imageAttachment)
//
//        let fullString = NSMutableAttributedString()
//        fullString.append(attachmentString) // Add the image first
//        fullString.append(NSAttributedString(string: " Start DrugBox"))
//        label.attributedText = fullString
//        
//        return label
//    }()

    
    // UI Components
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    private let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.ptdRegularFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "AppGreen")
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.ptdRegularFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "AppBlue")
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
        configureFCM()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(contentView) // Add contentView to the main view
        contentView.addSubview(titleLabel) // Add titleLabel to contentView
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(registerButton)
        contentView.addSubview(googleLoginButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).offset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.left.right.equalTo(loginButton)
            make.height.equalTo(50)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(20)
            make.left.right.equalTo(loginButton)
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureFCM() {
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM token: \(error)")
//            } else if let token = token {
//                print("FCM token: \(token)")
//                self.fcmToken = token
//                LoginViewController.keychain.set(token, forKey: "FCMToken")
//            }
//        }
    }
    
    // MARK: - Button Actions
    @objc private func buttonPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        if let userData = assignLoginData(email: email, password: password) {
            callLogin(userData: userData) { isSuccess in
                if isSuccess {
                    self.navigationController?.pushViewController(MenuSelectViewController(), animated: true)
                } else {
                    print("로그인 정보가 없습니다.")
                }
            }
        } else {
            print("UserData 생성 오류")
        }
        
    }
    
    @objc private func registerButtonPressed() {
        // Replace with appropriate action or segue
        print("Register button pressed.")
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func googleLogin() {
        // Google login setup
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
            guard let self = self,
                  let result = signInResult,
                  let token = result.user.idToken?.tokenString else { return }
            
            let accesstoken = result.user.accessToken.tokenString
            let refreshtoken = result.user.refreshToken.tokenString
            
            // Keychain store
            LoginViewController.keychain.set(accesstoken, forKey: "GoogleAccessToken")
            LoginViewController.keychain.set(refreshtoken, forKey: "GoogleRefreshToken")
            
            // Use tokens as needed
            guard let fcmToken = self.fcmToken else {
                print("FCM token not available")
                return
            }
            let oauthData = self.assignGoogleLoginData(aToken: accesstoken, fcmToken: fcmToken, idToken: token)
            // Further OAuth handling
        }
    }
    
    // MARK: - API Call Functions
    private func callLogin(userData: UserLoginRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postLogin(param: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let rData = try response.map(TokenDto.self)
                    print(rData)
                    LoginViewController.keychain.set(rData.accessToken, forKey: "serverAccessToken")
                    completion(true)
                } catch {
                    print("Failed to map data: \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("Request failed: \(error)")
                completion(false)
            }
        }
    }
    
    private func assignLoginData(email: String, password: String) -> UserLoginRequest? {
        if let fcmtoken = LoginViewController.keychain.get("FCMToken") {
            return UserLoginRequest(email: email, password: password, fcmToken: fcmtoken)
        }
        return nil
    }
    
    private func assignGoogleLoginData(aToken: String, fcmToken: String, idToken: String) -> OAuthLoginRequest {
        return OAuthLoginRequest(accessToken: aToken, fcmToken: fcmToken, idToken: idToken)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
