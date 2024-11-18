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
    private let boxImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8 // 둥근 모서리
        return imageView
    }()
    
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
        contentView.addSubview(boxImage)
        
        boxNameLabel.font = UIFont.ptdBoldFont(ofSize: 20)
        boxNameLabel.textColor = .black
        boxNameLabel.textAlignment = .left
        boxNameLabel.numberOfLines = 0
        contentView.addSubview(boxNameLabel)
        
        settingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingButton.tintColor = UIColor(named: "AppGrey")
        settingButton.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
        contentView.addSubview(settingButton)
    }
    
    
    private func setupConstraints() {
        
        boxImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(130)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(30)
        }
        
        boxNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalTo(settingButton.snp.leading).inset(-8)
            make.leading.equalTo(boxImage.snp.trailing).offset(12)
            make.height.equalTo(40)
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
