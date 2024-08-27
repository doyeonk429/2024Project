//
//  LoginService.swift
//  DrugBox
//
//  Created by 김도연 on 6/18/24.
//

import Foundation
import Moya
import KeychainSwift

enum LoginService {
    // 자체 로그인
    case postLogin(param: UserLoginRequest)
    case postRegister(param: UserLoginRequest)
    // 구글 로그인
    case postGoogleLogin(param: OAuthLoginRequest)
    case postLogout(accessToken: String)
    case postQuit(accessToken: String)
}

extension LoginService : TargetType {
    var baseURL : URL {
        return URL(string: K.apiURL.loginbaseURL)!
    }
    
    var path : String {
        switch self {
        case .postLogin : return "login/pw"
        case .postRegister : return "signup/pw"
        case .postGoogleLogin : return "login/google"
        case .postLogout : return "logout"
        case .postQuit : return "quit"
        }
    }
    
    var method : Moya.Method {
        switch self {
        case .postLogin : return .post
        case .postRegister : return .post
        case .postGoogleLogin : return .post
        case .postLogout : return .post
        case .postQuit : return .post
        }
    }
    
    var task : Task {
        switch self {
        case .postLogin(let param) :
//            return .requestJSONEncodable(param)
            return .requestParameters(parameters: ["userLoginRequest" : param], encoding: JSONEncoding.default)
        case .postRegister(let param) :
//            return .requestJSONEncodable(param)
            let jsonData = try! JSONEncoder().encode(param)
            let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            return .requestParameters(parameters: ["userLoginRequest": jsonDict], encoding: JSONEncoding.default)
//            return .requestParameters(parameters: ["userLoginRequest" : param], encoding: JSONEncoding.default)
        case .postGoogleLogin(let param) :
//            return .requestJSONEncodable(param)
            return .requestParameters(parameters: ["request" : param], encoding: JSONEncoding.default)
        case .postLogout(let accessToken) :
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: JSONEncoding.default)
        case .postQuit(let accessToken) :
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
