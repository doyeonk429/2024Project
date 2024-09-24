//
//  BoxManageService.swift
//  DrugBox
//
//  Created by 김도연 on 6/18/24.
//

import UIKit
import Moya
import KeychainSwift

enum BoxManageService {
    // list page
    case getBoxes // drugbox/user
    
    // adding page
    case postCreateBox(image: UIImage, imageName: String, name: String) // drugbox
    case postJoinBox(inviteCode: String) // drugbox/invite-code
    case postInviteBox(param: BoxInvitationPost) // drugbox/invitation
    case postAddBoxbyCode(invitationId: Int) // drugbox/invitation/{invitationId} - 초대 수락하기
    
    // setting page
    case getSetting(id: Int) // drugbox/setting
    case patchBoxName(id: Int, name: String) // drugbox/setting/name
    case patchBoxImage(id : Int, image: UIImage, imageName : String) // drugbox/setting/image
    
}

extension BoxManageService : TargetType {
    var baseURL: URL {
        return URL(string: "http://13.125.191.198:8080/drugbox")!
    }
    
    var path: String {
        switch self {
        case .getBoxes:
            return "/user"
        case .postCreateBox:
            return ""
        case .postJoinBox:
            return "/invite-code"
        case .postInviteBox:
            return "/invitation"
        case .postAddBoxbyCode(let code):
            return "/invitation/\(code)"
        case .getSetting:
            return "/setting"
        case .patchBoxName:
            return "/setting/name"
        case .patchBoxImage:
            return "/setting/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBoxes, .getSetting:
            return .get
        case .patchBoxName, .patchBoxImage :
            return .patch
        default :
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getBoxes :
            return .requestPlain
        case .getSetting(let id) :
//            return .requestParameters(parameters: ["drugboxId" : id], encoding: JSONEncoding.default)
            return .requestParameters(parameters: ["drugboxId": id], encoding: URLEncoding.queryString)
        case .postCreateBox(let image, let imageName, let name) :
            var formData : [MultipartFormData] = []
            
            if let nameData = name.data(using: .utf8) {
                let nameMultipart = MultipartFormData(provider: .data(nameData), name: "name")
                formData.append(nameMultipart)
            }
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let imageMultipart = MultipartFormData(provider: .data(imageData), name: "image", fileName: imageName, mimeType: "image/jpeg")
                formData.append(imageMultipart)
            }
            return .uploadMultipart(formData)
        case .postJoinBox(let inviteCode) :
            return .requestParameters(parameters: ["inviteCode" : inviteCode], encoding: JSONEncoding.default)
        case .postInviteBox(let data) :
            return .requestJSONEncodable(data)
        case .postAddBoxbyCode(let invitId) :
            return .requestParameters(parameters: ["invitationId" : invitId], encoding: JSONEncoding.default)
        case .patchBoxName(let id, let name) :
            return .requestParameters(parameters: ["drugboxId" : id, "name" : name], encoding: URLEncoding.queryString)
        case .patchBoxImage(let id, let image, let imageName) :
            var formData : [MultipartFormData] = []
            
            let idData = "\(id)".data(using: .utf8) ?? Data()
            let idMultipart = MultipartFormData(provider: .data(idData), name: "drugboxId")
            formData.append(idMultipart)
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let imageMultipart = MultipartFormData(provider: .data(imageData), name: "image", fileName: imageName, mimeType: "image/jpeg")
                formData.append(imageMultipart)
            }
            
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postCreateBox, .patchBoxImage :
            return ["Content-type": "multipart/form-data"]
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
