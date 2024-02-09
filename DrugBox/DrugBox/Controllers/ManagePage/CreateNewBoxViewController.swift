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
    
    override func viewWillAppear(_ animated: Bool) {
        self.BoxNameLabel.text = ""
        self.ImageView.image = UIImage(systemName: "photo.artframe")
    }
    
//MARK: - alert tap for selecting image
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
    
//MARK: - go to create box with inviteCode
    @IBAction func invitationCodeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.manageSegue.invitationCodeSegue, sender: self)
    }
    
//MARK: - call POST API with boxModel
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if boxName != "" {
            let resizedImage = ImageView.image!.resizeImage(image: ImageView.image!, newWidth: 300)
            self.fileUpload(id: userid, name: boxName, img: resizedImage)
            // 정상 포스팅 되는 경우에만..
            DispatchQueue.main.async {
                self.BoxNameLabel.text = ""
                self.ImageView.image = UIImage(systemName: "photo.artframe")
                self.presentingViewController?.dismiss(animated: true)
            }
        }
    }
    
    func fileUpload(id userId: Int, name boxName: String, img: UIImage) -> Void {
        // 헤더 구성 : Content-Type 필드에 multipart 타입추가
        let header: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "multipart/form-data"
        ]
        let parameters : [String: Any] = ["userId" : userId, "name" : boxName]
        let imageData = img.jpegData(compressionQuality: 1)
        
        AF.upload(multipartFormData: { MultipartFormData in
            // body 추가
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            // image data 추가
            if let image = imageData {
                MultipartFormData.append(image, withName: "file", fileName: "test.jpeg", mimeType: "image/jpeg")
            }
        }, to: K.apiURL.POSTboxURL, method: .post, headers: header)
        .validate(statusCode: 200..<500)
//        .responseData { <#AFDataResponse<Data>#> in
//            <#code#>
//            // response 받아서 error handle...
//        }
        
        
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

struct DrugBox {
    static let boxData = DrugBox()
    
    // 헤더 구성 : Content-Type 필드에 multipart 타입추가
    let header: HTTPHeaders = [
        "Accept" : "application/json",
        "Content-Type" : "multipart/form-data"
    ]
    
//    func fileUpload(id userId: Int, name boxName: String, _ img: UIImage) -> Int{
//        let parameters : [String: Any] = [
//            "userId" : userId, "name" : boxName
//        ]
//        let imageData = img.jpegData(compressionQuality: 1)
//        
//        AF.upload(multipartFormData: { MultipartFormData in
//            // body 추가
//            for (key, value) in parameters {
//                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//            // image data 추가
//            if let image = imageData {
//                MultipartFormData.append(image, withName: "file", fileName: "test.jpeg", mimeType: "image/jpeg")
//            }
//        }, to: addUrl
//        ,method: .post
//                  ,headers: header).responseData { <#AFDataResponse<Data>#> in
//            <#code#>
//        }
//        
//        return 0
//    }
}
