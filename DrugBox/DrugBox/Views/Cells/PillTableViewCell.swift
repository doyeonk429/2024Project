//
//  PillDataCell.swift
//  DrugBox
//
//  Created by 김도연 on 11/20/24.
//

import UIKit
import SnapKit
import SDWebImage

class PillTableViewCell: UITableViewCell {
    
    static let identifier = "PillTableViewCell"
    
    private let pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium // 인디케이터 추가
        return imageView
    }()
    
    private let pillNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let pillSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pillImageView)
        contentView.addSubview(pillNameLabel)
        contentView.addSubview(pillSubtitleLabel)
        
        // 레이아웃 설정
        pillImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
            make.width.height.equalTo(80)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        pillNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(pillImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        pillSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pillNameLabel.snp.bottom).offset(5)
            make.left.equalTo(pillImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with pill: PillData) {
        pillNameLabel.text = pill.품목명
        pillSubtitleLabel.text = "\(pill.분류명) | \(pill.전문일반구분)"
        
        if let imageUrl = URL(string: pill.큰제품이미지) {
            pillImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
