//
//  MapResponse.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import Foundation

struct MapResponse : Codable {
    let latitude : String
    let locationAddress : String
    let locationId : String
    let locationName : String
    let longitude : String
}

struct BinLocationResponse : Codable {
    let addrLvl1 : String
    let addrLvl2 : String
    let address : String
    let detail : String
    let id : Int
    let lat : String
    let lng : String
}

struct MapDetailResponse : Codable {
    let currentOpeningHours : String
    let formattedAddress : String
    let locationId : String
    let locationName : String
    let locationPhotos : String
}
