//
//  MapService.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit
import Moya
import KeychainSwift

enum MapService {
    // 주변
    case getMedicalLocations(loc : LocationParameter)
    // map/nearby
    
    // 폐의약품 관련 장소만
    case getSeoulDrugbins // map/seoul
    case getDivisionDrugbins(addr : AddrParameter) // map/division
    
    // 검색 & 장소 정보
    case getSearchLocation(name : String) // map/search
    case getLocationDetails(id : String) // map/detail
}

extension MapService : TargetType {
    var baseURL: URL {
        return URL(string: "http://13.125.191.198:8080/maps")!
    }
    
    var path: String {
        switch self {
        case .getMedicalLocations :
            return "/nearby"
        case .getSeoulDrugbins :
            return "/seoul"
        case .getDivisionDrugbins :
            return "/division"
        case .getSearchLocation :
            return "/search"
        case .getLocationDetails :
            return "/detail"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getMedicalLocations(let loc) :
            return .requestParameters(parameters: ["latitude": loc.latitude, "longitude" : loc.longitude], encoding: URLEncoding.queryString)
        case .getSeoulDrugbins :
            return .requestPlain
        case .getDivisionDrugbins(let addr) :
            return .requestParameters(parameters: ["addrLvl1": addr.Addr1, "addrLvl2": addr.Addr2], encoding: URLEncoding.queryString)
        case .getSearchLocation(let name) :
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
        case .getLocationDetails(let id) :
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
