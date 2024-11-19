//
//  UserLoginRequest.swift
//  DrugBox
//
//  Created by 김도연 on 8/24/24.
//

import Foundation

struct UserLoginRequest : Codable {
    let email : String
    let password : String
    let fcmToken : String
}
struct UserSignUpRequest : Codable {
    let email : String
    let password : String
}
