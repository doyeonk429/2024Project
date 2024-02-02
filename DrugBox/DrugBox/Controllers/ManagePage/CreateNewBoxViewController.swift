//
//  CreateNewBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit

class CreateNewBoxViewController: UIViewController {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var BoxNameLabel: UITextField!
    @IBOutlet weak var BoxCodeLabel: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var ImagePickButton: UIButton!
    
    let picker = UIImagePickerController()
    let userid: Int = 0 // dummy -> 나중에 로그인 연결하면 설정하기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        BoxNameLabel.delegate = self
        BoxCodeLabel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func pickButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "사진을 가져올 곳 선택", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) {
            (action) in self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let boxname = BoxNameLabel.text {
            if let boxImage = ImageView.image {
                let boxModel = BoxModel(userId: userid, boxName: boxname, boxImage: boxImage)
                // post request 호출
            } else {
                // 이미지 선택하지 않을 경우 기본 이미지 전달해서 박스 제작
            }
        } else {
            // 박스 이름 설정하지 않을 경우 경고 메세지
        }
        
    }
}

extension CreateNewBoxViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera is not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.ImageView.image = image
            }
//            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateNewBoxViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        BoxNameLabel.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use searchTextField.text to get the weather for that city.
        if let name = BoxNameLabel.text {
//            weatherManager.fetchWeather(cityName: city)
        }
    }
}
