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
    
    struct DeletePageURL {
        static let seoulDistricts: [String: String] = [
            "강남구": "https://www.gangnam.go.kr/board/waste/list.do?mid=ID02_011109#collapse21",
            "강동구": "https://www.gangdong.go.kr/web/newportal/contents/gdp_005_004_010_001",
            "강북구": "https://www.gangbuk.go.kr:18000/portal/bbs/B0000089/list.do?menuNo=200294",
            "강서구": "https://www.gangseo.seoul.kr/env/env010501",
            "관악구": "https://www.gwanak.go.kr/site/gwanak/09/10903060000002023030704.jsp",
            "광진구": "https://www.gwangjin.go.kr/dong/bbs/B0000127/view.do?nttId=6197129&menuNo=600909&dongCd=09",
            "구로구": "https://www.guro.go.kr",
            "금천구": "https://www.geumcheon.go.kr/portal/contents.do?key=4409",
            "노원구": "https://www.nowon.kr/dong/user/bbs/BD_selectBbs.do?q_bbsCode=1042&q_bbscttSn=20230713101112740",
            "도봉구": "https://www.dobong.go.kr/subsite/waste/Contents.asp?code=10010125",
            "동대문구": "https://www.ddm.go.kr/www/contents.do?key=858",
            "동작구": "https://www.dongjak.go.kr/portal/main/contents.do?menuNo=201627",
            "마포구": "https://mbs.mapo.go.kr/mapoapp/hotnews_view.asp?idx=16423",
            "서대문구": "https://www.sdm.go.kr/health/board/1/10410?activeMenu=0104010000",
            "서초구": "https://www.seocho.go.kr/site/seocho/04/10414020800002023100603.jsp",
            "성동구": "https://www.sd.go.kr/main/contents.do?key=4522&",
            "성북구": "https://www.sb.go.kr/main/cop/bbs/selectBoardArticle.do?bbsId=B0319_main&nttId=9502165&menuNo=94000000&subMenuNo=94110000&thirdMenuNo=&fourthMenuNo=",
            "송파구": "https://www.songpa.go.kr/ehealth/selectBbsNttView.do?nttNo=19240469&pageUnit=10&bbsNo=179&key=4713&pageIndex=1",
            "양천구": "https://www.yangcheon.go.kr/site/yangcheon/05/10507040000002023122903.jsp",
            "영등포구": "https://www.ydp.go.kr/www/contents.do?key=5982&",
            "용산구": "https://www.yongsan.go.kr/portal/main/contents.do?menuNo=201150",
            "은평구": "https://www.ep.go.kr/www/contents.do?key=4499",
            "종로구": "https://www.jongno.go.kr",
            "중구": "https://www.junggu.seoul.kr/content.do?cmsid=15918",
            "중랑구": "https://dong.jungnang.go.kr/dong/bbs/view/B0000002/31788?menuNo=500012"
        ]

    }
}
