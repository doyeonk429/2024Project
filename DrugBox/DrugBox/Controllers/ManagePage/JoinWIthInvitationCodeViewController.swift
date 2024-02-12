//
//  JoinWIthInvitationCodeViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/3/24.
//

import UIKit

class JoinWIthInvitationCodeViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var JoinButton: UIButton!
    var usedId: Int = 1 // 로그인 상태에서 정보 가져옴
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        if let code = codeTextField.text{
            self.postInvitationCode(by: self.usedId, with: code)
        }
    }
    
    func postInvitationCode(by userid: Int, with inviteCode: String) {
        let postURL = "\(K.apiURL.baseURL)/add/invite-code?inviteCode=\(inviteCode)&userId=\(userid)"
        var request = URLRequest(url: URL(string: postURL)!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error : \(error)")
            }
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }
        task.resume()
        dispatchMain()
    }
    
}

extension JoinWIthInvitationCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        codeTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let code = codeTextField.text{
            self.postInvitationCode(by: self.usedId, with: code)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if codeTextField.text != ""{
            return true
        } else {
            codeTextField.placeholder = "초대코드를 입력해주세요"
            return false
        }
    }
}


