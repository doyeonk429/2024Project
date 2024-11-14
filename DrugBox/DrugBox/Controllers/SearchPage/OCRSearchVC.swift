//
//  OCRSearchVC.swift
//  DrugBox
//
//  Created by 김도연 on 11/13/24.
//

import UIKit
import SnapKit

class OCRSearchVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let ocrModel = OCRModel()

    // 선택한 이미지를 표시할 UIImageView
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 인식된 텍스트를 표시할 UILabel
    private let recognizedTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0  // 여러 줄 표시 가능하도록 설정
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white  // 배경색 설정

        // 이미지 선택 버튼 추가
        let selectImageButton = UIButton(type: .system)
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        
        // UI 요소들을 뷰에 추가
        view.addSubview(selectedImageView)
        view.addSubview(recognizedTextLabel)
        view.addSubview(selectImageButton)
        
        // SnapKit을 사용해 레이아웃 설정
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(selectedImageView.snp.width)
        }
        
        recognizedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        selectImageButton.snp.makeConstraints { make in
            make.top.equalTo(recognizedTextLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
    }
    
    // 이미지 선택 후 OCR 수행
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            // 선택한 이미지를 UIImageView에 표시
            selectedImageView.image = image
            
            // OCR 수행
            ocrModel.performOCR(on: image) { recognizedText in
                DispatchQueue.main.async {
                    // 인식된 텍스트를 UILabel에 표시
                    self.recognizedTextLabel.text = recognizedText.joined(separator: "\n")
                }
            }
        }
    }
    
    // 이미지 선택을 시작하는 메서드
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}
