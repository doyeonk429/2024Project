//
//  LoginViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//  Modifed by doyeonk429 on 3/4/24.
import UIKit
import GoogleSignIn

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
        let parameters = "{\r\n    \"email\": \"\(email)\",\r\n    \"password\": \"\(pw)\"\r\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: K.apiURL.loginURL)!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                        print(String(describing: error))
                        exit(EXIT_SUCCESS)
                }
                print(String(data: data, encoding: .utf8)!)
                exit(EXIT_SUCCESS)
        }

        task.resume()
        dispatchMain()
    }
}

