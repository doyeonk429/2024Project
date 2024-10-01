//
//  MenuView.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit
import SnapKit
import Then

class MenuView: UIView {

    // MARK: - UI Components

    public lazy var titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    public lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponents()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI Components
    
    private func addComponents() {
        self.addSubview(titleLabel)
        self.addSubview(tableView)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        // SafeAreaLayoutGuide를 사용해서 safe area 내에 맞춰 제약을 설정
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

