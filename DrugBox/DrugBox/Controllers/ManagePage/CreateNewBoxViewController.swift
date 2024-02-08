//
//  CreateNewBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire

class CreateNewBoxViewController: UIViewController {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var BoxNameLabel: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var ImagePickButton: UIButton!
    @IBOutlet weak var invitationCodeButton: UIButton!
    
    let picker = UIImagePickerController()
    var boxManager = BoxManager()
    
    var userid: Int = 1 // dummy -> 나중에 로그인 연결하면 설정하기
    var boxName: String = ""
//    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        BoxNameLabel.delegate = self
        
        invitationCodeButton.titleLabel?.setUnderline(range: NSRange(location: 0, length: invitationCodeButton.currentTitle?.count ?? 0))
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
    
    
    @IBAction func invitationCodeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.manageSegue.invitationCodeSegue, sender: self)
    }
    // image 리사이즈하는걸 어디서?
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if boxName != "" {
            let resizedImage = ImageView.image!.resizeImage(image: ImageView.image!, newWidth: 300)
//            boxManager.fileUpload(userid, boxName, <#T##img: UIImage##UIImage#>, completion: <#T##(String) -> Void#>)
                // post 함수 call
//                boxManager.sendNewBoxModel(userid, boxName, imageURL)
//                boxManager.fileUpload(userid, boxName, <#T##img: UIImage##UIImage#>, completion: <#T##(String) -> Void#>)
                BoxNameLabel.text = ""
                // 이미지뷰에 있는 이미지 기본 이미지로 초기화
            }
        
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
//                self.imageURL = "\(info[UIImagePickerController.InfoKey.imageURL]!)"
//                print(self.imageURL)
            }
//            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - UITextFieldDelegate
extension CreateNewBoxViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        BoxNameLabel.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // boxnamelabel 전달
        if let name = BoxNameLabel.text {
            self.boxName = name
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if BoxNameLabel.text != ""{
            return true
        } else {
            BoxNameLabel.placeholder = "구급상자의 이름을 지정해주세요"
            return false
        }
    }
}
