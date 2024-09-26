//
//  DisposalDrugCell.swift
//  DrugBox
//
//  Created by 김도연 on 9/25/24.
//

import UIKit
import SnapKit
import Then

class DisposalDrugCell: UITableViewCell {
    
    // Checkbox Image View
    let checkboxImageView = UIImageView().then {
        $0.image = UIImage(systemName: "square") // Default to unchecked state
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    let firstLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    let secondLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(checkboxImageView)
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
        
        checkboxImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(firstLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
