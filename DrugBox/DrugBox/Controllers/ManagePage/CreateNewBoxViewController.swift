//
//  CreateNewBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/31/24.
//

import UIKit
import Alamofire
import Moya

class CreateNewBoxViewController: UIViewController {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var BoxNameLabel: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var ImagePickButton: UIButton!
    @IBOutlet weak var invitationCodeButton: UIButton!
    
    let picker = UIImagePickerController()
    var boxManager = BoxManager()
    var boxName : String = ""
    private var imageName : String = ""
    private var image : UIImage = UIImage()
    
    //MARK: - API provider
    let provider = MoyaProvider<BoxManageService>(plugins: [BearerTokenPlugin()])
    
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
//            let resizedImage = ImageView.image!.resizeImage(image: ImageView.image!, newWidth: 300)
//            print("현재 설정된 이미지 \(image), 이미지 이름 \(imageName), 박스 이름 \(boxName)")
            callPostNewBox { isSuccess in
                if isSuccess {
                    // reset 후, dismiss
                    self.presentingViewController?.dismiss(animated: true)
                } else {
                    print("데이터 전송 실패")
                }
            }
        }
    }
    
    //MARK: - API call func
    private func callPostNewBox(completion : @escaping (Bool) -> Void) {
        provider.request(.postCreateBox(image: image, imageName: imageName, name: boxName)) { result in
            switch result {
            case .success(let response) :
                do {
                    let responseData = try response.map(IdResponse.self)
                    print("정상 Post된 box id : \(responseData.id)")
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
                completion(true)
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

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateNewBoxViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 라이브러리 선택
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    // 카메라 선택
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera is not available")
        }
    }
    
    // 이미지 선택 완료 후, 현재 이미지뷰에 선택된 이미지 삽입
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.ImageView.image = image
                let fileName = "\(UUID().uuidString).jpeg"
                self.setImageInfo(img: image, imgName: fileName)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // 선택된 이미지 정보 저장
    private func setImageInfo(img : UIImage, imgName : String) {
        self.image = img
        self.imageName = imgName
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

