//
//  AddNewMemberViewController.swift
//  DrugBox
//
//  Created by 김도연 on 11/18/24.
//

import UIKit
import SnapKit
import Toast

class AddNewMemberViewController: UIViewController {
    
    

    // MARK: - UI Elements
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "초대할 닉네임을 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        return textField
    }()
    
    private let inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("초대하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let inviteCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "초대코드"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let inviteCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "" // 기본값
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    // MARK: - Properties
    var boxID: Int?
    var inviteCode: String = ""
    private let pasteboard = UIPasteboard.general

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        nicknameTextField.delegate = self
        view.backgroundColor = .white
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(inviteButton)
        view.addSubview(inviteCodeTitleLabel)
        view.addSubview(inviteCodeLabel)
        view.addSubview(copyButton)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        inviteButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        inviteCodeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(inviteButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        inviteCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(inviteCodeTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        copyButton.snp.makeConstraints { make in
            make.centerY.equalTo(inviteCodeLabel)
            make.leading.equalTo(inviteCodeLabel.snp.trailing).offset(10)
            make.width.height.equalTo(24)
        }
    }
    
    // MARK: - Actions
    private func setupActions() {
        inviteButton.addTarget(self, action: #selector(inviteButtonPressed), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyButtonPressed), for: .touchUpInside)
    }
    
    @objc private func inviteButtonPressed() {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            nicknameTextField.placeholder = "닉네임을 입력해주세요"
            return
        }
        print("초대하기 버튼 클릭 - 닉네임: \(nickname)")
        // 여기에 API 호출 코드 추가 가능
    }
    
    @objc private func copyButtonPressed() {
        pasteboard.string = inviteCodeLabel.text
        view.makeToast("Copied!", duration: 2.0, position: .bottom)
    }
}

// MARK: - UITextFieldDelegate
extension AddNewMemberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknameTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let nickname = nicknameTextField.text, !nickname.isEmpty {
            print("입력된 닉네임: \(nickname)")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if nicknameTextField.text?.isEmpty == false {
            return true
        } else {
            nicknameTextField.placeholder = "닉네임을 입력해주세요"
            return false
        }
    }
}
