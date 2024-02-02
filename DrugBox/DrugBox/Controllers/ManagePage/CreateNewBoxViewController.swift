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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
            ImageView.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}
