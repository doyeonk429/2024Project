//
//  DrugDetailSaveRequest.swift
//  DrugBox
//
//  Created by 김도연 on 8/30/24.
//

import Foundation

struct DrugDetailSaveRequest : Codable {
    let count : Int
    let expDate : String
    let location : String
}
