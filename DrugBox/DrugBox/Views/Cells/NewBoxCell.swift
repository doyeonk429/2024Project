//
//  NewBoxCell.swift
//  DrugBox
//
//  Created by 김도연 on 11/10/24.
//

import UIKit
import SnapKit

//protocol ButtonTappedDelegate: AnyObject {
//    func cellButtonTapped(_ tag: Int)
//}

class NewBoxCell: UITableViewCell {
    // UI elements
    private let boxImage = UIImageView()
    private let boxNameLabel = UILabel()
    private let settingButton = UIButton(type: .system)
    
    // Properties
    var drugboxId: Int = 0
    weak var delegate: ButtonTappedDelegate?
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configure contentView appearance
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        
        // Configure and add subviews
        boxImage.contentMode = .scaleAspectFill
        contentView.addSubview(boxImage)
        
        boxNameLabel.font = UIFont.systemFont(ofSize: 16)
        boxNameLabel.textColor = .black
        boxNameLabel.backgroundColor = .systemGray // Set background color to systemGray
        boxNameLabel.textAlignment = .center
        boxNameLabel.layer.cornerRadius = 5
        boxNameLabel.clipsToBounds = true // Enable corner radius
        contentView.addSubview(boxNameLabel)
        
        settingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingButton.tintColor = UIColor(named: "AppGrey")
        settingButton.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
        contentView.addSubview(settingButton)
    }
    
    
    private func setupConstraints() {
        boxImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(5)
            make.height.equalTo(boxImage.snp.width).multipliedBy(3.0 / 4.0)
            }
        
        // boxNameLabel constraints - 이미지의 왼쪽 상단에 배치
        boxNameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(boxImage).offset(10)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(30)
        }
        
        // settingButton constraints - 오른쪽 상단에 위치
        settingButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(10)
        }
        
    }
    
    @objc private func settingButtonPressed() {
        delegate?.cellButtonTapped(drugboxId)
    }
    
    // Public method to configure cell contents
    func configure(with imageURL: URL?, name: String, id: Int) {
        if let url = imageURL {
            self.boxImage.loadImage(url: url)
        } else {
            self.boxImage.image = UIImage(systemName: K.drugboxDefaultImage)
        }
        boxNameLabel.text = name
        self.drugboxId = id
        settingButton.tag = id
    }
}
