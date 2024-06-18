//
//  BoxManageService.swift
//  DrugBox
//
//  Created by 김도연 on 6/18/24.
//

import Foundation
import Moya
import KeychainSwift

enum BoxManageService {
    // list page
    case getBoxes // drugbox/user
    
    // adding page
    case postCreateBox(box: MultipartFormData) // drugbox/add
    case postJoinBox(inviteCode: String) // drugbox/invite-code
    case postInviteBox(param: BoxInvitationPost) // drugbox/invitation
    case postAddBoxbyCode(invitationId: Int) // drugbox/invitation/{invitationId}
    
    // setting page
    case getSetting(id: Int) // drugbox/setting
    case patchBoxName(param: BoxNamePatch) // drugbox/setting/name
    case patchBoxImage(param: MultipartFormData) // drugbox/setting/image
    
}

extension BoxManageService {
    var baseURL: URL {
        return URL(string: K.apiURL.drugBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getBoxes:
            return "user"
        case .postCreateBox:
            return "add"
        case .postJoinBox:
            return "invite-code"
        case .postInviteBox:
            return "invitation"
        case .postAddBoxbyCode(let code):
            return "invitation/\(code)"
        case .getSetting:
            return "setting"
        case .patchBoxName:
            return "setting/name"
        case .patchBoxImage:
            return "setting/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBoxes : return .get
        case .getSetting : return .get
        case .patchBoxName : return .patch
        case .patchBoxImage : return .patch
        default : return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getBoxes :
            return .requestPlain
        case .getSetting(let id) :
            return .requestParameters(parameters: ["drugboxId" : id], encoding: URLEncoding.queryString)
        case .postCreateBox(let box) :
            return .uploadMultipart([box])
        case .postJoinBox(let inviteCode) :
            return .requestParameters(parameters: ["inviteCode" : inviteCode], encoding: URLEncoding.queryString)
        case .postInviteBox(let param) :
            return .requestJSONEncodable(param)
        case .postAddBoxbyCode(let invitId) :
            return .requestParameters(parameters: ["invitationId" : invitId], encoding: URLEncoding.queryString)
        case .patchBoxName(let param) :
            return .requestJSONEncodable(param)
        case .patchBoxImage(let param) :
            return .uploadMultipart([param])
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default :
            let accessToken: String = LoginViewController.keychain.get("serverAccessToken")!
            return ["Content-Type": "application/json", "Token" : accessToken]
        }
    }
}


struct BoxNamePatch : Codable{
    let drugboxId: Int
    let name: String
}

struct BoxInvitationPost : Codable {
    let drugboxId: Int
    let nickname: String
}

