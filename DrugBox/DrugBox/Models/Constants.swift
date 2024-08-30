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
    static let onboardingSegue = "OnboardingToLogin"
    static let registerSegue = "ToRegister"
    
    struct tableCell {
        static let cellIdentifier = "ReusableCell"
        
        static let cellNibName = "AlarmCell"
        static let contentCellNibName = "WayToDelete"
        
        static let boxCellNibName = "BoxCell"
        static let boxCellIdentifier = "BoxCell"
        
        static let drugCellNibName = "DrugCell"
        static let drugCellIdentifier = "DrugCell"
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
        static let baseServer = "13.125.191.198:8080"
        static let baseURL = "http://\(baseServer)/"
        static let drugBaseURL = "\(baseURL)drugbox/"
        static let loginbaseURL = "\(baseURL)auth/"
        
        static let POSTboxURL = "\(baseURL)add"
        static let GETboxListURL = "\(baseURL)/user"
        static let GETboxDetailURL = "\(baseURL)setting?drugboxId="
        static let POSTinviteURL = "\(baseURL)invite?drugboxId="
        
        static let GETDrugURL = "\(drugBaseURL)list?drugboxId="
    }
}
