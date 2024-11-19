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
    
    case getDrugDetail(boxId: Int, drugName: String)
    case patchDrugDisposal(boxId: Int, drugid: Int)
    case getDisposalList
    case deleteDisposal(data : [DrugUpdateRequest])
}

extension DrugService : TargetType {
    var baseURL: URL {
        return URL(string: "http://13.125.191.198:8080/drugs")!
    }
    
    var path: String {
        switch self {
        case .getSearchResult, .getDrugDetail:
            return "/search-result"
        case .patchDrugDisposal, .getDisposalList, .deleteDisposal:
            return "/disposal"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postDrugs:
            return .post
        case .patchDrugs, .patchDrugDisposal:
            return .patch
        case .deleteDisposal:
            return .delete
        default :
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getDrugs(let id):
            return .requestParameters(parameters: ["drugboxId" : id], encoding: URLEncoding.queryString)
        case .postDrugs(let data):
            return .requestJSONEncodable(data)
        case .patchDrugs(let data):
            return .requestJSONEncodable(data)
        case .getSearchResult(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
        case .getDrugDetail(let boxId, let drugName):
            return .requestParameters(parameters: ["drugboxId": boxId, "name" : drugName], encoding: URLEncoding.queryString)
        case .patchDrugDisposal(boxId: let boxId, drugid: let drugid):
            return .requestParameters(parameters: ["drugboxId": boxId, "drugId": drugid], encoding: URLEncoding.queryString)
        case .getDisposalList:
            return .requestPlain
        case .deleteDisposal(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
    
}
