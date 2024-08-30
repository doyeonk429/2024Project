//
//  DrugSaveRequest.swift
//  DrugBox
//
//  Created by 김도연 on 8/30/24.
//

import Foundation

struct DrugSaveRequest : Codable {
    let detail : DrugDetailSaveRequest
    let drugboxId : Int
    let name : String
    let type : String
}
