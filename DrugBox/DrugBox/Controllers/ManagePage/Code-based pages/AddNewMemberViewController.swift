//
//  AddNewMemberViewController.swift
//  DrugBox
//
//  Created by 김도연 on 11/18/24.
//

import UIKit
import SnapKit
import Toast
import Moya

class AddNewMemberViewController: UIViewController {
    
    let provider = MoyaProvider<BoxManageService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    
    // MARK: - UI Elements
    private let inviteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "멤버 초대하기"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
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
        
        inviteCodeLabel.text = inviteCode
        nicknameTextField.delegate = self
        view.backgroundColor = .white
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(inviteTitleLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(inviteButton)
        view.addSubview(inviteCodeTitleLabel)
        view.addSubview(inviteCodeLabel)
        view.addSubview(copyButton)
        
        inviteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(inviteTitleLabel.snp.bottom).offset(20) // "팀원 초대하기" 아래에 배치
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
        
        guard let boxid = self.boxID else {
            return
        }
        
        postInvitationByName(data: setupInvitationData(boxId: boxid, nickname: nickname)) { isSuccess in
            if isSuccess {
                print("초대하기 성공 - 닉네임: \(nickname)")
                let defaultBoxListVC = DrugBoxListVC()
                self.navigationController?.pushViewController(defaultBoxListVC, animated: true)
            } else {
                print("데이터 전송 실패")
            }
        }
        
    }
    
    @objc private func copyButtonPressed() {
        pasteboard.string = inviteCodeLabel.text
        view.makeToast("Copied!", duration: 2.0, position: .bottom)
    }
    
    private func setupInvitationData(boxId : Int, nickname: String) -> BoxInvitationPost {
        return BoxInvitationPost(drugboxId: boxId, nickname: nickname)
    }
    
    private func postInvitationByName(data: BoxInvitationPost, completion: @escaping (Bool) -> Void) {
        provider.request(.postInviteBox(param: data)) { result in
            switch result {
            case .success(let response) :
                do {
                    let responseData = try response.map(IdResponse.self)
                    print("정상 초대된 box id : \(responseData.id)")
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
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
