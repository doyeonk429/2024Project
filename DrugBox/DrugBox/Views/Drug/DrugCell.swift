//
//  DrugCell.swift
//  DrugBox
//
//  Created by 김도연 on 2/18/24.
//

//import UIKit
//
//class DrugCell: UITableViewCell {
//    
//    @IBOutlet weak var CheckButton: UIButton!
//    @IBOutlet weak var DrugCountLabel: UILabel!
//    @IBOutlet weak var DrugNameLabel: UILabel!
//    
//    weak var delegate: CheckBoxDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//    
//    @IBAction func checkButtonPressed(_ sender: UIButton) {
//        // delegate.OnCheck()
//    }
//}

import UIKit
import SnapKit
import Then

class DrugCell: UITableViewCell {

    // UI 요소 생성
    let checkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
    }
    
    let drugCountLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .darkGray
    }
    
    let drugNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }

    weak var delegate: CheckBoxDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        // UI 요소들을 셀에 추가
        contentView.addSubview(checkButton)
        contentView.addSubview(drugCountLabel)
        contentView.addSubview(drugNameLabel)
        
        // 레이아웃 설정
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // checkButton 레이아웃
        checkButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30) // 버튼 크기 설정
        }
        
        // drugNameLabel 레이아웃
        drugNameLabel.snp.makeConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(16)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        // drugCountLabel 레이아웃
        drugCountLabel.snp.makeConstraints { make in
            make.left.equalTo(drugNameLabel)
            make.top.equalTo(drugNameLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "checkmark.square") {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        
        // 델리게이트 호출
        delegate?.onCheck()
    }
}

