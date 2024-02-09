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
    var boxName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BoxNameLabel.text = boxName
        print(drugBoxId ?? 0)
        
    }
    

}
