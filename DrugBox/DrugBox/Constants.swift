//
//  Constants.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import Foundation

struct K {
    static let appName = "DrugBox"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "AlarmCell"
//    static let registerSegue = "RegisterToChat"

    
    struct mainSegue {
        static let loginSegue = "LoginToMenuSelect"
        static let alarmSegue = "MenuToAlarm"
        static let manageSegue = "MenuToManage"
        static let deleteSegue = "MenuToDelete"
        static let searchSegue = "MenuToSearch"
    }
    
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
