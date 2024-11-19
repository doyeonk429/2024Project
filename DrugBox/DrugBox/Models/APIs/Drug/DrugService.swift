//
//  DrugService.swift
//  DrugBox
//
//  Created by 김도연 on 8/30/24.
//

import UIKit
import Moya

enum DrugService {
    case getDrugs(boxId: Int)
    case postDrugs(data: DrugSaveRequest)
    case patchDrugs(data : DrugUpdateRequest)
    case getSearchResult(name: String)
}

extension DrugService : TargetType {
    var baseURL: URL {
        return URL(string: "http://13.125.191.198:8080/drugs")!
    }
    
    var path: String {
        switch self {
        case .getSearchResult:
            return "/search-result"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDrugs:
            return .get
        case .postDrugs:
            return .post
        case .patchDrugs:
            return .patch
        case .getSearchResult:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDrugs(let id):
            return .requestParameters(parameters: ["drugboxId" : id], encoding: JSONEncoding.default)
        case .postDrugs(let data):
            return .requestParameters(parameters: ["drugSaveRequest" : data], encoding: JSONEncoding.default)
        case .patchDrugs(let data):
            return .requestJSONEncodable(data)
        case .getSearchResult(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
    
}
