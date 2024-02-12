//
//  DefaultBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit
import Alamofire

class DefaultBoxViewController: UIViewController {
    
    @IBOutlet weak var boxTableView: UITableView!
    var currentDrugbox : Int?
    
    // 테이블 셀 선택 시 해당 구급상자 내의 알약 정보 get 해서 다음 페이지에 넘겨주기
    var boxList: [BoxListModel] = [
        BoxListModel(name: "test-01", drugboxId: 1, imageURL: ""),
        BoxListModel(name: "test-02", drugboxId: 12, imageURL: "")
    ]
    //    var testList: [tempModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxTableView.delegate = self
        boxTableView.dataSource = self
        boxTableView.register(UINib(nibName: K.tableCell.boxCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.boxCellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 뷰 갓다와서 업데이트할 건 여기다가
        let userid = MenuSelectViewController.userID
        //        getDrugBoxList(userid) // 데이터 없어서 에러뜸 잠시
        
        // 다시 화면으로 돌아왔을 때 선택 해제
        if let selectedIndexPath = boxTableView.indexPathForSelectedRow {
            boxTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 이거 왜 실행이 안되는가..
        if segue.identifier == K.manageSegue.showItemSegue {
            
        } else if segue.identifier == K.manageSegue.settingSegue {
            // setting 페이지에서 get api 호출에 필요한 data 넘겨줌
//            print("호출됨!!!!!!!성공!!!!!!")
//            print(self.currentDrugbox!)
            let destinationVC = segue.destination as! BoxSettingViewController
            destinationVC.drugBoxId = self.currentDrugbox!
            
        }
    }
    
    //MARK: - GET api
    // box GET api 호출 함수
    func getDrugBoxList(_ userId: Int) -> Void {
        //        print("box get api 호출")
        let urlString = "\(K.apiURL.GETboxListURL)\(userId)"
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

extension DefaultBoxViewController: UITableViewDataSource, UITableViewDelegate {
    // 테이블 셀 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let box = boxList[indexPath.row]
        let cell = boxTableView.dequeueReusableCell(withIdentifier: K.tableCell.boxCellIdentifier, for: indexPath) as! BoxCell
        
        cell.BoxNameLabel.text = " \(box.name)"
        if let url = URL(string: box.imageURL) {
            cell.boxImage.loadImage(url: url)
        } else {
            cell.boxImage.image = UIImage(systemName: K.drugboxDefaultImage)
        }
        cell.drugboxId = box.drugboxId
        cell.SettingButton.tag = box.drugboxId
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //테이블뷰의 이벤트처리 함수
//        print("테이블뷰 셀이 클릭 되었다!")
        // segue call
        self.performSegue(withIdentifier: K.manageSegue.showItemSegue, sender: self)
        self.prepare(for: UIStoryboardSegue.init(identifier: K.manageSegue.showItemSegue, source: self, destination: ItemListViewController()), sender: self)
        
//        boxTableView.deselectRow(at: indexPath, animated: true) // 색 원상태로 복귀
    }
    
}

extension DefaultBoxViewController: ButtonTappedDelegate {
    func cellButtonTapped(_ buttonTag: Int) {
        self.currentDrugbox = buttonTag
        self.performSegue(withIdentifier: K.manageSegue.settingSegue, sender: self)
//        self.prepare(for: UIStoryboardSegue.init(identifier: K.manageSegue.settingSegue, source: self, destination: BoxSettingViewController()), sender: UIButton.self) -- 이거 왜고민한거야...!!!!!!1(극대노)
    }
}
