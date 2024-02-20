//
//  LoginViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.loginSegue, sender: self)
    }
    
    
    @IBAction func googleLoginButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
    }
    
}
