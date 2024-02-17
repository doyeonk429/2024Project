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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func parseJSON(_ data: Data) -> [DrugModel] {
        var returnList : [DrugModel] = []
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode([DrugListData].self, from: data)
            for data in decodedData {
                let boxId = data.id
                let drugName = data.name
                let drugCount = data.count
                let location = data.location
                let expDate = data.expDate
                let inDisposalList = data.inDisposalList
                returnList.append(DrugModel(boxId: boxId, drugName: drugName, drugCount: drugCount, location: location, expDate: expDate, inDisposalList: inDisposalList))
                
            }
        }
    }
}

extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
