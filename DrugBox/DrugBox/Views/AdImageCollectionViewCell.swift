//
//  AdImageCollectionViewCell.swift
//  DrugBox
//
//  Created by 김도연 on 9/24/24.
//
import UIKit

class AdImageCollectionViewCell : UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupUI() {
        self.contentView.addSubview(imageView)
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
            
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    func configure(image: String) {
        if let image = UIImage(named: image) {
            imageView.image = image
        }
    }
}

