//
//  DefaultBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit
import Alamofire

class DefaultBoxViewController: UIViewController, UITableViewDelegate {
    
    // 테이블 뷰 구현해야함
    // 테이블 셀 선택 시 해당 구급상자 내의 알약 정보 get 해서 다음 페이지에 넘겨주기
    var boxList: [BoxListModel] = []
    var testList: [tempModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 다른 뷰 갓다와서 업데이트할 건 여기다가
        let userid = MenuSelectViewController.userID
        getDrugBoxList(userid)
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
//MARK: - GET api
// box GET api 호출 함수
    func getDrugBoxList(_ userId: Int) -> Void {
//        print("box get api 호출")
        var urlString = "\(K.apiURL.GETboxListURL)\(userId)"
//        let urlString = "https://jsonplaceholder.typicode.com/todos?userId=1"
//        print(urlString)
        
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
//                    let json = try JSONSerialization.jsonObject(with: data)
//                    print(json)
//                    self.testList = self.parseJSON(data)
                    self.boxList = self.parseJSON(data)
//                    for i in self.testList {
//                        print(i.id)
//                        print(i.userId)
//                        print(i.title)
//                        print("---")
//                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> [BoxListModel] {
        var returnList : [BoxListModel] = []
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode([BoxListData].self, from: data)
            for data in decodedData {
                let name = data.name
                let drugboxId = data.drugboxId
                let imageURL = data.imageURL
                returnList.append(BoxListModel(name: name, drugboxId: drugboxId, imageURL: imageURL))
            }
        }
        return returnList
    }
}
//MARK: - test model
struct tempModel: Codable {
    let id: Int
    let title: String
    let userId: Int
}
//MARK: - box for listview model
struct BoxListModel: Codable {
    let name: String
    let drugboxId: Int
    let imageURL: String
}
//MARK: - test data
struct tempData: Codable{
    let completed: Bool
    let id: Int
    let title: String
    let userId: Int
}

struct BoxListData: Codable {
    let name: String
    let drugboxId: Int
    let imageURL: String
    let inviteCode: String
}
