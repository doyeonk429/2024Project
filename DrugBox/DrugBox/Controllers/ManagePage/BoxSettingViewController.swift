//
//  BoxSettingViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/9/24.
//

import UIKit
import Alamofire
import Moya


class BoxSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    let provider = MoyaProvider<BoxManageService>(plugins: [BearerTokenPlugin()])
    let provider = MoyaProvider<BoxManageService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    let picker = UIImagePickerController()
    private var imageName : String = ""
    private var image : UIImage = UIImage()
    
    let tableView = UITableView()
    
    private let BoxNameLabel: UILabel = {
        let l = UILabel()
        l.text = "박스 이름"
        l.font = .systemFont(ofSize: 20)
        l.textColor = .black
        l.numberOfLines = 0
        return l
    }()
    
    private let SettingLabel: UILabel = {
        let l = UILabel()
        l.text = "설정"
        l.font = .systemFont(ofSize: 16)
        l.textColor = .lightGray
        l.numberOfLines = 0
        return l
    }()
    
    private let TableTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "구성원"
        l.font = .systemFont(ofSize: 18)
        l.textColor = .black
        l.numberOfLines = 0
        return l
    }()
    
    let BoxImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit // 이미지 비율을 유지하면서 뷰에 맞게 조정
        $0.clipsToBounds = true // 이미지가 뷰의 경계를 넘어가지 않도록 설정
        $0.image = UIImage(systemName: "photo") // 기본 이미지 설정 (예: 빈 이미지 아이콘)
        $0.backgroundColor = .white // 이미지가 없을 때의 배경색
    }
    
    // addButton 생성
    let MemberAddButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        $0.tintColor = .lightGray
//        $0.setTitle("Add", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
    }
    
    // editButton 생성
    let NameLabelEditButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        $0.tintColor = .lightGray
//        $0.setTitle("Edit", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
    }
    
    // editButton 생성
    let ImageChangeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        $0.tintColor = .lightGray
        $0.setTitle("사진 바꾸기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
    }
    
    public var drugBoxId : Int?
    var boxSetting = BoxSettingModel(boxName: "", drugboxId: 0, imageURL: "", inviteCode: "", users: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        callGetSetting { isSuccess in
            if isSuccess {
                if let imageURL = URL(string: self.boxSetting.imageURL) {
                    self.BoxImageView.loadImage(url: imageURL)
                }
                self.BoxNameLabel.text = self.boxSetting.boxName
            }
        }
        
        setNameUI()
        NameLabelEditButton.addTarget(self, action: #selector(changeName), for: .touchUpInside)
        setImageUI()
        ImageChangeButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        setUserTableUI()
        
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callGetSetting { isSuccess in
            if isSuccess {
                if let imageURL = URL(string: self.boxSetting.imageURL) {
                    self.BoxImageView.loadImage(url: imageURL)
                }
                self.BoxNameLabel.text = self.boxSetting.boxName
            }
        }
    }
    
    //MARK: - UI setting codes
    private func setNameUI() {
        view.addSubview(BoxNameLabel)
        view.addSubview(SettingLabel)
        view.addSubview(NameLabelEditButton)
        
        BoxNameLabel.snp.makeConstraints { l in
            l.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            l.centerX.equalToSuperview()
            l.height.greaterThanOrEqualTo(20)
        }
        
        SettingLabel.snp.makeConstraints { make in
            make.top.equalTo(BoxNameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(16)
        }
        
        NameLabelEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(BoxNameLabel.snp.centerY)
            make.leading.equalTo(BoxNameLabel.snp.trailing).offset(4)
        }
    }
    
    private func setImageUI() {
        view.addSubview(BoxImageView)
        view.addSubview(ImageChangeButton)
        
        BoxImageView.snp.makeConstraints { make in
            make.top.equalTo(SettingLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(BoxImageView.snp.width).multipliedBy(3.0/4.0)
        }
        
        ImageChangeButton.snp.makeConstraints { make in
            make.top.equalTo(BoxImageView.snp.bottom).offset(4) // BoxImageView의 하단에서 4pt 떨어짐
            make.centerX.equalToSuperview() // 수평 중앙 정렬
        }
    }
    
    private func setUserTableUI() {
        view.addSubview(TableTitleLabel)
        view.addSubview(MemberAddButton)
        view.addSubview(tableView)
        
        TableTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ImageChangeButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        MemberAddButton.snp.makeConstraints { make in
            make.top.equalTo(TableTitleLabel)
            make.leading.equalTo(TableTitleLabel.snp.trailing).offset(4)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(TableTitleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
//    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: K.manageSegue.inviteSegue, sender: self)
//    }
    
    //MARK: - Button Actions
    @objc func changeImage() {
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
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func changeName() {
        let nameChangeVC = BoxSettingNameViewController()
        nameChangeVC.drugboxId = boxSetting.drugboxId
        nameChangeVC.modalPresentationStyle = .fullScreen
        self.present(nameChangeVC, animated: true, completion: nil)
    }
    
    @objc func goToAddMemberPage() {
        
    }
    
    //MARK: - API func
    private func callGetSetting(completion : @escaping (Bool) -> Void) {
        if let id = self.drugBoxId {
            provider.request(.getSetting(id: id)) { result in
                switch result {
                case .success(let response) :
                    do {
                        let data = try response.map(DrugboxSettingResponse.self)
                        print(data)
                        self.boxSetting = BoxSettingModel(boxName: data.name, drugboxId: data.drugboxId, imageURL: data.image, inviteCode: data.inviteCode, users: data.users)
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
    
    //MARK: - TableView Settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.boxSetting.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        // configure 메서드를 통해 nameLabel의 텍스트 설정
        cell.configure(with: "\(boxSetting.users[indexPath.row].userId)")
        
        return cell
    }
    
}

//MARK: - ImagePicker
extension BoxSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                self.BoxImageView.image = image
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
        // moya patch call
    }
}

struct BoxSettingModel : Codable {
    let boxName: String
    let drugboxId: Int
    let imageURL: String
    let inviteCode: String
    let users: [UserResponse]
}


