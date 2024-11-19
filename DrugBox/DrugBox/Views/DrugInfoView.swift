//
//  DrugInfoView.swift
//  DrugBox
//
//  Created by 김도연 on 11/19/24.
//

import UIKit
import SnapKit

class DrugInfoView: UIView {

    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "개수"
        label.font = UIFont.ptdRegularFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let countValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0개"
        label.font = UIFont.ptdMediumFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    

}
