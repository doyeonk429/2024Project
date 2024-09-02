//
//  DrugBoxResponse.swift
//  DrugBox
//
//  Created by 김도연 on 8/27/24.
//

import Foundation

struct DrugBoxResponse : Codable {
    let drugboxId : Int
    let image : String
    let inviteCode : String
    let name : String
}

//struct APIDrugboxResponse : Codable {
//    let boxList : [DrugBoxResponse]
//}
