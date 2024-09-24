//
//  InfoViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/3/24.
//

import UIKit
import SnapKit
import Then

class InfoViewController: UIViewController {

    
    private let titleLabel = UILabel().then {
        $0.text = "거주 지역을 선택하세요(현재 서울시만 지원)"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        view.addSubview(titleLabel)
        // Do any additional setup after loading the view.
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
}
