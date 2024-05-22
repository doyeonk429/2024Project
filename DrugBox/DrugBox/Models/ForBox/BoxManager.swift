//
//  BoxManager.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire

struct BoxManager {
    
    func parseJSON(_ data: Data) -> [BoxListModel] {
        var returnList : [BoxListModel] = []
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode([BoxListData].self, from: data)
            for data in decodedData {
                let name = data.name
                let drugboxId = data.drugboxId
                let imageURL = data.imageURL
                returnList.append(BoxListModel(name: name, drugboxId: drugboxId, imageURL: imageURL))
            }
        }
        return returnList
    }
    
    
    
}
