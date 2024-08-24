//
//  OAuthLoginRequest.swift
//  DrugBox
//
//  Created by 김도연 on 8/24/24.
//

import Foundation

// 구글 로그인 request
struct OAuthLoginRequest : Codable {
    let accessToken : String
    let fcmToken : String
    let idToken : String
}
