//
//  CreateNewBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire
import Moya
import SnapKit

class CreateNewBoxViewController: UIViewController {
    
    // UI Components
    private let imageView = UIImageView()
    private let boxNameTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    private let imagePickButton = UIButton(type: .system)
    private let invitationCodeButton = UIButton(type: .system)
    
    let picker = UIImagePickerController()
    var boxManager = BoxManager()
    var boxName: String = ""
    private var imageName: String = ""
    private var image: UIImage = UIImage()
    
    // API provider
    let provider = MoyaProvider<BoxManageService>(plugins: [BearerTokenPlugin()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        picker.delegate = self
        boxNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        boxNameTextField.text = ""
        imageView.image = UIImage(systemName: "photo.artframe")
    }
    
    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .white
        
        // Image View
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        // Text Field
        boxNameTextField.placeholder = "구급상자 이름"
        boxNameTextField.borderStyle = .roundedRect
        boxNameTextField.delegate = self
        view.addSubview(boxNameTextField)
        
        // Image Pick Button
        imagePickButton.setTitle("이미지 선택", for: .normal)
//        imagePickButton.setTitleColor(.white, for: .normal) // 텍스트 색상
//        imagePickButton.backgroundColor = UIColor(named: "AppBlue")
//        imagePickButton.layer.cornerRadius = 10             // 둥근 모서리
        imagePickButton.addTarget(self, action: #selector(pickButtonPressed), for: .touchUpInside)
        view.addSubview(imagePickButton)
        
        // Save Button
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.white, for: .normal) // 텍스트 색상
        saveButton.backgroundColor = UIColor(named: "AppGreen")
        saveButton.layer.cornerRadius = 10             // 둥근 모서리
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Invitation Code Button
        invitationCodeButton.setTitle("초대 코드 입력", for: .normal)
        invitationCodeButton.setTitleColor(.appGrey, for: .normal)
        invitationCodeButton.titleLabel?.attributedText = NSAttributedString(string: "초대 코드 입력하기", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        invitationCodeButton.addTarget(self, action: #selector(invitationCodeButtonPressed), for: .touchUpInside)
        view.addSubview(invitationCodeButton)
    }
    
    // MARK: - Constraints Setup
    private func setupConstraints() {
        boxNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(boxNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(imageView.snp.width).multipliedBy(3.0 / 4.0)
        }
        
        imagePickButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(imagePickButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        invitationCodeButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(40)
            make.leading.trailing.equalTo(saveButton)
        }
    }
    
    // MARK: - Button Actions
    @objc func pickButtonPressed() {
        let alert = UIAlertController(title: "사진을 가져올 곳 선택", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { _ in self.openLibrary() }
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func invitationCodeButtonPressed() {
        let vc = AddNewBoxByCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveButtonPressed() {
        if boxName != "" {
            callPostNewBox { isSuccess in
                if isSuccess {
//                    self.presentingViewController?.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("데이터 전송 실패")
                }
            }
        }
    }
    
    // MARK: - API Call
    private func callPostNewBox(completion: @escaping (Bool) -> Void) {
        provider.request(.postCreateBox(image: image, imageName: imageName, name: boxName)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try response.map(IdResponse.self)
                    print("정상 Post된 box id : \(responseData.id)")
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateNewBoxViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera is not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            let fileName = "\(UUID().uuidString).jpeg"
            setImageInfo(img: image, imgName: fileName)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setImageInfo(img: UIImage, imgName: String) {
        self.image = img
        self.imageName = imgName
    }
}

// MARK: - UITextFieldDelegate
extension CreateNewBoxViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        boxNameTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = boxNameTextField.text {
            self.boxName = name
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if boxNameTextField.text != "" {
            return true
        } else {
            boxNameTextField.placeholder = "구급상자의 이름을 지정해주세요"
            return false
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = boxNameTextField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else {return false}
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        
//        return updatedText.count <= 15
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트
        let currentText = boxNameTextField.text ?? ""
        
        // 한글 조합 중인 텍스트 (markedTextRange가 nil이 아니면 조합 중)
        if let markedTextRange = boxNameTextField.markedTextRange,
           let _ = boxNameTextField.position(from: markedTextRange.start, offset: 0) {
            return true // 조합 중인 텍스트는 제한하지 않음
        }
        
        // 입력 후 텍스트
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > 15 {
            // 경고 표시
            showCharacterLimitAlert()
            return false
        }
        
        // 글자 수 제한
        return true
    }
    
    private func showCharacterLimitAlert() {
        let alert = UIAlertController(title: "경고", message: "최대 15자까지 입력 가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
