//
//  UserCell.swift
//  DrugBox
//
//  Created by 김도연 on 9/3/24.
//

import UIKit
import SnapKit
import Then

class UserCell: UITableViewCell {
    
    // NameLabel 생성
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // NameLabel을 셀에 추가
        contentView.addSubview(nameLabel)
        
        // 레이아웃 설정
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // nameLabel의 레이아웃 설정
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()    // 수직 가운데 정렬
            make.left.equalToSuperview().offset(16) // 왼쪽에 16pt 여백
            make.right.equalToSuperview().offset(-16) // 오른쪽에 16pt 여백
        }
    }
    
    // configure 메서드 추가
    func configure(with name: String) {
        nameLabel.text = name
    }
}

