//
//  LabelTableViewCell.swift
//  DrugBox
//
//  Created by 김도연 on 9/24/24.
//

import UIKit
import SnapKit
import Then

class LabelTableViewCell: UITableViewCell {
    
    // Define a label for the cell
    let cellLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    // Initialize the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the cell's subviews
    private func setupViews() {
        contentView.addSubview(cellLabel)
        
        // Add constraints using SnapKit
        cellLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

