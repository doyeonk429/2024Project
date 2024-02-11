//
//  BoxSettingViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/9/24.
//

import UIKit
import Alamofire

class BoxSettingViewController: UIViewController {
    
    @IBOutlet weak var BoxImageView: UIImageView!
    @IBOutlet weak var NameLabelEditButton: UIButton!
    @IBOutlet weak var BoxNameLabel: UILabel!
    @IBOutlet weak var MemberAddButton: UIButton!
    @IBOutlet weak var ImageChangeButton: UIButton!
    @IBOutlet weak var MemberTableView: UITableView!
    
    var drugBoxId : Int?
    var boxSetting : BoxSettingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBoxDetail(drugBoxId ?? 0)
        
        DispatchQueue.main.async {
            self.BoxNameLabel.text = self.boxSetting?.boxName
            if let url = URL(string: self.boxSetting!.imageURL) {
                self.BoxImageView.loadImage(url: url)
            } else {
                self.BoxImageView.image = UIImage(systemName: K.drugboxDefaultImage)
            }
        }
        
    }
    
    
    @IBAction func editNameButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
    }
    
    // api call
//    func patchImage(_ img: UIImage) {
//        
//    }
    // api call
//    func patchName(_ name: String, _ boxId: Int) {
//        let urlString = "\(K.apiURL.baseURL)/setting/name?drugboxId=\(boxId)&name=\(name)"
//    }
    
//MARK: - GET api
    func getBoxDetail(_ drugBoxId: Int){
        let urlString = "\(K.apiURL.GETboxDetailURL)\(drugBoxId)"
        print(urlString)
        if let url = URL(string: urlString) {
            // 2. create a URLSession
            let session = URLSession(configuration: .default)
            // 3. give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {
                    print("no data")
                    return
                }
                do {
                    self.boxSetting = self.parseJSON(data)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> BoxSettingModel? {
        var boxsetting : BoxSettingModel?
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode(BoxSettingData.self, from: data)
            let name = decodedData.boxName
            let drugboxId = decodedData.drugboxId
            let imageURL = decodedData.imageURL
            let users = decodedData.users
            boxsetting = BoxSettingModel(boxName: name, drugboxId: drugboxId, imageURL: imageURL, users: users)
        }
        return boxsetting
    }
    
}

struct BoxSettingModel {
    let boxName: String
    let drugboxId: Int
    let imageURL: String
//    let inviteCode: String
    let users: [User]
}

struct BoxSettingData: Codable {
    let boxName: String
    let drugboxId: Int
    let imageURL: String
    let inviteCode: String
    let users: [User]
}

struct User: Codable{
    let nickname: String
    let userId: Int
}

