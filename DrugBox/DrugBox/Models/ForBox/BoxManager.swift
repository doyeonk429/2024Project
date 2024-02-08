//
//  BoxManager.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire

struct BoxManager {
    func postInvitationCode(by userid: Int, with inviteCode: String) {
//        let postURL = "\(url)/add/invite-code?inviteCode=\(inviteCode)&userId=\(userid)"
        var request = URLRequest(url: URL(string: postURL)!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
//                self.delegate?.didFailWithError(error: error!)
                return
            }
        }
        
        task.resume()
    }
    
    func fetchDrugboxDetail(drugboxId: Int) {
//        var urlString = "\(url)setting?drugboxId=\(drugboxId)"
//        performRequest(with: urlString, type: 1)
    }
    
    
    
}
