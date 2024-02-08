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
    var boxManager = BoxManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        if let code = codeTextField.text{
            boxManager.postInvitationCode(by: self.usedId, with: code)
        }
    }
    
}

extension JoinWIthInvitationCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        codeTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let code = codeTextField.text{
            boxManager.postInvitationCode(by: self.usedId, with: code)
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

extension JoinWIthInvitationCodeViewController: BoxManagerDelegate {
    func didFailWithError(error: Error) {
        //에러 경고창 띄우기
        // 리퀘보내고 받은 response에 대한 에러
    }
    
    
}
