//
//  DrugDetailResponse.swift
//  DrugBox
//
//  Created by 김도연 on 11/19/24.
//

import UIKit

struct DrugDetailResponse: Codable {
    let drugResponses : [DrugReponse]
    let effect : String
    let name: String
}

struct DrugReponse : Codable {
    let count : Int
    let expDate : String
    let id : Int
    let inDisposalList : Bool
    let location : String
    let name : String
}

struct DrugInfoResponse: Codable {
    let id : Int
    let name : String
    let effect : String
    let updateDate : String
}

struct DisposalResponse : Codable {
    let drugResponses : [DrugReponse]
    let drugboxId : Int
    let drugboxName : String
}
