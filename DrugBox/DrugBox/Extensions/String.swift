//
//  String.swift
//  DrugBox
//
//  Created by 김도연 on 2/17/24.
//

import UIKit

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
