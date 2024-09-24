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
        $0.text = "내 폐의약품 목록"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textAlignment = .left
        $0.textColor = .systemGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        // Do any additional setup after loading the view.
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
}
