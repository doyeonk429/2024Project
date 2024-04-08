//
//  InviteViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/12/24.
//

import UIKit
import Alamofire

class InviteViewController: UIViewController {
    @IBOutlet weak var NicknameTextField: UITextField!
    @IBOutlet weak var InviteButton: UIButton!
    @IBOutlet weak var InviteCodeLabel: UILabel!
    @IBOutlet weak var CopyButton: UIButton!
    
    var boxID: Int?
    var InviteCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InviteCodeLabel.text = InviteCode
        NicknameTextField.delegate = self
    }
    
    @IBAction func inviteButtonPressed(_ sender: UIButton) {
        if let nickname = NicknameTextField.text {
            self.postTest(boxID!, nickname)
        }
        
    }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        
    }
    
    func postInviteapi(_ drugboxId: Int, _ nickname: String) {
        let urlString: String = "\(K.apiURL.POSTinviteURL)\(drugboxId)&nickname=\(nickname)"
        
        
        
    }
    
    func postTest(_ drugboxId: Int, _ nickname: String) {
            let url = "http://ptsv3.com/t/yejun-980116/post/"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
            // POST 로 보낼 정보
            let params = ["drugboxId": drugboxId, "nickname": nickname] as Dictionary
            
            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
            }
            AF.request(request).responseString { (response) in
                switch response.result {
                case .success:
                    print("POST 성공")
                case .failure(let error):
                    print("error : \(error.errorDescription!)")
                }
            }
        }
    
}

extension InviteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NicknameTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let nickname = NicknameTextField.text{
            print(nickname)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if NicknameTextField.text != ""{
            return true
        } else {
            NicknameTextField.placeholder = "내용을 입력해주세요"
            return false
        }
    }
}

