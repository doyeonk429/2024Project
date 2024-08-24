//
//  TokenDto.swift
//  DrugBox
//
//  Created by 김도연 on 8/24/24.
//

import Foundation

// 구글 로그인 response
struct TokenDto : Codable {
    let accessToken : String
    let accessTokenExpiresIn : Int
    let grantType : String
    let isNewUser : Bool
    let refreshToken : String
    let refreshTokenExpiresIn : Int
    let userId : Int
}
