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
    let csvParser = CSVParser()
    public var modelResultTexts : [PillData] = []

    // 선택한 이미지를 표시할 UIImageView
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 인식된 텍스트를 표시할 UITextView
    private let recognizedTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false // 편집 비활성화
        textView.isSelectable = true
        textView.font = UIFont.ptdThinFont(ofSize: 16)
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isScrollEnabled = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white  // 배경색 설정

        // 이미지 선택 버튼 추가
        let selectImageButton = UIButton(type: .system)
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        
        let goToResultVCButton = UIButton(type: .system)
        goToResultVCButton.setTitle("약 검색결과 보러가기", for: .normal)
        goToResultVCButton.addTarget(self, action: #selector(resultBtnTapped), for: .touchUpInside)
        
        // UI 요소들을 뷰에 추가
        view.addSubview(selectedImageView)
        view.addSubview(recognizedTextView)
        view.addSubview(selectImageButton)
        view.addSubview(goToResultVCButton)
        
        // SnapKit을 사용해 레이아웃 설정
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(selectedImageView.snp.width)
        }
        
        selectImageButton.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        recognizedTextView.snp.makeConstraints { make in
            make.top.equalTo(selectImageButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        goToResultVCButton.snp.makeConstraints { make in
            make.top.equalTo(recognizedTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.bottom.equalToSuperview().inset(10)
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
                self.modelResultTexts = self.csvParser.searchPillDatas(by: recognizedText) ?? []
                DispatchQueue.main.async {
                    // 인식된 텍스트를 UITextView에 표시
                    self.recognizedTextView.text = recognizedText.joined(separator: "\n")
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
    
    @objc func resultBtnTapped() {
        let resultVc = DrugSearchByLabelViewController()
        resultVc.ocrSearchStringList = modelResultTexts
        navigationController?.pushViewController(resultVc, animated: true)
    }
}
