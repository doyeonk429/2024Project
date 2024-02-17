//
//  Constants.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import Foundation

struct K {
    static let appName = "DrugBox"
    static let drugboxDefaultImage = "shippingbox"
    static let loginSegue = "LoginToMenuSelect"
//    static let registerSegue = "RegisterToChat"
    
    struct tableCell {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "AlarmCell"
        static let contentCellNibName = "WayToDelete"
        static let boxCellNibName = "BoxCell"
        static let boxCellIdentifier = "BoxCell"
    }

    
    struct mainSegue {
        static let alarmSegue = "MenuToAlarm"
        static let manageSegue = "MenuToManage"
        static let deleteSegue = "MenuToDelete"
        static let searchSegue = "MenuToSearch"
    }
    
    struct manageSegue {
        static let createSegue = "DefaultToCreate"
        static let invitationCodeSegue = "ToJoinInvitationCode"
        static let showItemSegue = "BoxListToItemList"
        static let settingSegue = "ToSetting"
        static let inviteSegue = "ToInvite"
    }
    
    struct deleteSegue {
        static let showInformationContents = "ToInfo"
    }
    
    struct BrandColors {
//        static let purple = "BrandPurple"
//        static let lightPurple = "BrandLightPurple"
//        static let blue = "BrandBlue"
//        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
//        static let collectionName = "messages"
//        static let senderField = "sender"
//        static let bodyField = "body"
//        static let dateField = "date"
    }
    
    struct apiURL {
        static let baseURL = "http://104.196.48.122:8080/drugbox/"
        static let drugBaseURL = "http://104.196.48.122:8080/drugs/"
        
        static let POSTboxURL = "\(baseURL)add"
        static let GETboxListURL = "\(baseURL)user?userId="
        static let GETboxDetailURL = "\(baseURL)setting?drugboxId="
        static let POSTinviteURL = "\(baseURL)invite?drugboxId="
        
        static let GETDrugURL = "\(drugBaseURL)list?drugboxId="
    }
}
