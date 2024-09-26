//
//  AlarmCell.swift
//  DrugBox
//
//  Created by 김도연 on 9/26/24.
//

import UIKit
import SnapKit
import Then

class AlarmCell: UITableViewCell {

    let alarmLightIcon = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .lightGray
        $0.contentMode = .scaleAspectFit
    }

    let TimestampLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .darkGray
    }

    let AlarmContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
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
        contentView.addSubview(alarmLightIcon)
        contentView.addSubview(TimestampLabel)
        contentView.addSubview(AlarmContentLabel)

        alarmLightIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        TimestampLabel.snp.makeConstraints { make in
            make.leading.equalTo(alarmLightIcon.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
        }

        AlarmContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(alarmLightIcon.snp.trailing).offset(10)
            make.top.equalTo(TimestampLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}

