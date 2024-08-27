//
//  DrugboxSettingResponse.swift
//  DrugBox
//
//  Created by 김도연 on 8/27/24.
//

import Foundation

struct DrugboxSettingResponse : Codable {
    let drugboxId : Int
    let image : String
    let inviteCode : String
    let name : String
    let users : [UserResponse]
}
