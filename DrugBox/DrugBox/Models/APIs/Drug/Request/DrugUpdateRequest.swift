//
//  DrugUpdateRequest.swift
//  DrugBox
//
//  Created by 김도연 on 8/30/24.
//

import Foundation

struct DrugUpdateRequest : Codable {
    let drugIds : Int
    let drugboxId : Int
}
