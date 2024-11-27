//
//  UserSettingViewController.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit
import SnapKit
import Then

class UserSettingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.tintColor = .darkGray
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true // 사용자와 상호작용 가능하도록 설정
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "드럭박스테스터"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
    }
    
    private let nameEditButton = UIButton().then {
        let pencilImage = UIImage(systemName: "pencil")
        $0.setImage(pencilImage, for: .normal)
        $0.tintColor = .blue
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "t@g.com"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .gray
    }
    
    private let emailEditButton = UIButton().then {
        let pencilImage = UIImage(systemName: "pencil")
        $0.setImage(pencilImage, for: .normal)
        $0.tintColor = .blue
    }
    
//    private let logoutButton = UIButton().then {
//        $0.setTitle("로그아웃", for: .normal)
//        $0.setTitleColor(.lightGray, for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//    }
//    
//    private let deleteAccountButton = UIButton().then {
//        $0.setTitle("탈퇴하기", for: .normal)
//        $0.setTitleColor(.lightGray, for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupGestureRecognizer() // 프로필 사진을 클릭할 수 있게 설정
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameEditButton)
        view.addSubview(emailLabel)
        view.addSubview(emailEditButton)
//        view.addSubview(logoutButton)
//        view.addSubview(deleteAccountButton)
        
        // Set constraints using SnapKit
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-20)
        }
        
        nameEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.width.height.equalTo(24)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-20)
        }
        
        emailEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailLabel)
            make.left.equalTo(emailLabel.snp.right).offset(10)
            make.width.height.equalTo(24)
        }
        
//        logoutButton.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
//            make.centerX.equalToSuperview().offset(-20)
//        }
//        
//        deleteAccountButton.snp.makeConstraints { make in
//            make.top.equalTo(logoutButton.snp.top)
//            make.leading.equalTo(logoutButton.snp.trailing).offset(10)
//        }
    }
    
    // MARK: - Gesture Recognizer for Profile Image
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Select Profile Image
    
    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: "프로필 사진 변경", message: "사진을 선택해주세요.", preferredStyle: .actionSheet)
        
        // 사진 앨범에서 선택
        alert.addAction(UIAlertAction(title: "사진 앨범", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))
        
        // 카메라로 찍기
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { _ in
                self.openCamera()
            }))
        }
        
        // 취소 버튼
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // 사진 앨범 열기
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 카메라 열기
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage // 선택된 이미지를 프로필 이미지로 설정
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

