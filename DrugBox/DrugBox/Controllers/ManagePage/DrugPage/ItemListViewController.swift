//
//  ItemListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/4/24.
// 약 리스트 페이지. 멀티 선택 가능한

import UIKit
import Alamofire

class ItemListViewController: UIViewController {
    @IBOutlet weak var DrugTableView: UITableView!
    @IBOutlet weak var AddNewDrugButton: UIBarButtonItem!
    @IBOutlet weak var UseDrugButton: UIButton!
    
    var Drugs : [DrugModel] = []
    var drugBoxId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view 그릴 때 이전 페이지에서 정보 받아와야?함
        
        DrugTableView.delegate = self
        DrugTableView.dataSource = self
        DrugTableView.register(UINib(nibName: K.tableCell.drugCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.drugCellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func getDrugList(_ drugboxId: Int) {
        let urlString = "\(K.apiURL.GETDrugURL)\(drugboxId)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
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
                    //self.boxSetting = self.parseJSON(data)
                }
            }
            task.resume()
        }
    }
    //MARK: - json parsing function
    func parseJSON(_ data: Data) -> [DrugModel] {
        var returnList : [DrugModel] = []
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode([DrugListData].self, from: data)
            for data in decodedData {
                if let expDate = data.expDate.toDate() {
                    let boxId = data.id
                    let drugName = data.name
                    let drugCount = data.count
                    let location = data.location
                    let inDisposalList = data.inDisposalList
                    returnList.append(DrugModel(boxId: boxId, drugName: drugName, drugCount: drugCount, location: location, expDate: expDate, inDisposalList: inDisposalList))
                } else {
                    print("error : no expiry date data.")
                }
                
            }
        }
        return returnList
    }
}
//MARK: - TableView delegate Methods
extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drug = Drugs[indexPath.row]
        let cell = DrugTableView.dequeueReusableCell(withIdentifier: K.tableCell.drugCellIdentifier, for: indexPath) as! DrugCell
        
        cell.DrugNameLabel.text = "\(drug.drugName)"
        cell.DrugCountLabel.text = "\(drug.drugCount)"
        
//        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 약 상세 정보로 이동하도록 만들기
        //테이블뷰의 이벤트처리 함수
//        print("테이블뷰 셀이 클릭 되었다!")
        // segue call
//        self.performSegue(withIdentifier: K.manageSegue.showItemSegue, sender: self)
//        self.prepare(for: UIStoryboardSegue.init(identifier: K.manageSegue.showItemSegue, source: self, destination: ItemListViewController()), sender: self)
        
//        boxTableView.deselectRow(at: indexPath, animated: true) // 색 원상태로 복귀
    }
    
    
}


struct DrugListData: Codable{
    let id: Int
    let name: String
    let count: Int
    let location: String
    let expDate: String
    let inDisposalList: Bool
}
