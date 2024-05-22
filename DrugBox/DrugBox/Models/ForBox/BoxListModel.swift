//
//  BoxListModel.swift
//  DrugBox
//
//  Created by 김도연 on 5/22/24.
//

import UIKit

//MARK: - box for listview model
struct BoxListModel: Codable {
    let name: String
    let drugboxId: Int
    let imageURL: String
}
