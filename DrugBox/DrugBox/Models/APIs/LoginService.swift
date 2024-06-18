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
    case postLogin(param: DefaultLoginPost)
    case postRegister(param: DefaultLoginPost)
    case postGoogleLogin(param: GoogleLoginPost)
    case postLogout(accessToken: String)
    case postQuit(accessToken: String)
}

extension LoginService {
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
            return .requestJSONEncodable(param)
        case .postRegister(let param) :
            return .requestJSONEncodable(param)
        case .postGoogleLogin(let param) :
            return .requestJSONEncodable(param)
        case .postLogout(let accessToken) :
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: URLEncoding.queryString)
        case .postQuit(let accessToken) :
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}

struct DefaultLoginPost : Codable {
    let email, password : String
}
struct GoogleLoginPost : Codable {
    var accesstoken = LoginViewController.keychain.get("GoogleAccessToken")
    var refreshtoken = LoginViewController.keychain.get("GoogleRefreshToken")
    var fcmtoken = LoginViewController.keychain.get("FCMToken")
}
