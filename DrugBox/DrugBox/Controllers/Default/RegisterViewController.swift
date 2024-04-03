//
//  RegisterViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/22/24.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UserNameTextField: UITextField!
    
    //MARK: - Variables
    var userEmail : String?
    var userPW : String?
    var userName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK: - Actions
    @IBAction func CompletedButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

//MARK: - TextField Delegate Fuctions
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        <#code#>
    }
    

}
