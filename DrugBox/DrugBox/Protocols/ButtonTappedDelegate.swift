//
//  ButtonTappedDelegate.swift
//  DrugBox
//
//  Created by 김도연 on 2/9/24.
//

import UIKit

// 구급상자용
protocol ButtonTappedDelegate : AnyObject {
    func cellButtonTapped(_ buttonTag: Int)
}

// 약품 리스트 용
//protocol CheckBoxDelegate : AnyObject {
//    func OnCheck(_ curState: Bool)
//}

protocol CheckBoxDelegate: AnyObject {
    func onCheck(drugId: Int)
}
