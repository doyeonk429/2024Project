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
    @IBOutlet weak var BoxImageView: UIImageView!
    @IBOutlet weak var NameLabelEditButton: UIButton!
    @IBOutlet weak var BoxNameLabel: UILabel!
    @IBOutlet weak var MemberAddButton: UIButton!
    @IBOutlet weak var ImageChangeButton: UIButton!
    @IBOutlet weak var MemberTableView: UITableView!
    
    let provider = MoyaProvider<BoxManageService>(plugins: [BearerTokenPlugin()])
    
    public var drugBoxId : Int?
    var boxSetting = BoxSettingModel(boxName: "", drugboxId: 0, imageURL: "", inviteCode: "", users: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callGetSetting { isSuccess in
            if isSuccess {
                if let imageURL = URL(string: self.boxSetting.imageURL) {
                    self.BoxImageView.loadImage(url: imageURL)
                }
                self.BoxNameLabel.text = self.boxSetting.boxName
                
            }
        }
    }
    
    
    @IBAction func editNameButtonPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.manageSegue.inviteSegue, sender: self)
    }
    
    private func callGetSetting(completion : @escaping (Bool) -> Void) {
        if let id = self.drugBoxId {
            provider.request(.getSetting(id: id)) { result in
                switch result {
                case .success(let response) :
                    do {
                        let data = try response.map(DrugboxSettingResponse.self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.boxSetting.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

struct BoxSettingModel : Codable {
    let boxName: String
    let drugboxId: Int
    let imageURL: String
    let inviteCode: String
    let users: [UserResponse]
}

