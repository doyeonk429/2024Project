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
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    let secondLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .darkGray
        $0.numberOfLines = 1
    }
    
    let thirdLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .darkGray
        $0.numberOfLines = 1
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
        contentView.addSubview(thirdLabel)
        
        checkboxImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(8)
            make.width.equalTo(210)
            make.centerY.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(firstLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        thirdLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(secondLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    public func configure(_ name: String, _ count : Int, _ date : String) {
        self.firstLabel.text = name
        self.secondLabel.text = "\(count)개"
        self.thirdLabel.text = date
    }
}
