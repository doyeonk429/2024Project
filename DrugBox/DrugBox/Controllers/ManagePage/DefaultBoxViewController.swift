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
    var boxManager = BoxManager() // json data parsing functions
    var currentDrugbox : Int? // 선택한 drugbox의 id 저장 변수
    
    // 테이블 셀 선택 시 해당 구급상자 내의 알약 정보 get 해서 다음 페이지에 넘겨주기
    // UI test용 dummy data
    var boxList: [BoxListModel] = [
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDrugBoxList()

        boxTableView.delegate = self
        boxTableView.dataSource = self
        boxTableView.register(UINib(nibName: K.tableCell.boxCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.boxCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 뷰 갓다와서 업데이트할 건 여기다가
        
        getDrugBoxList()
        
        // 다시 화면으로 돌아왔을 때 선택 해제
        if let selectedIndexPath = boxTableView.indexPathForSelectedRow {
            boxTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
    
    //MARK: - Segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.manageSegue.showItemSegue {
            // drug 리스트 api 불러오는데 필요한 drugbox number 변수값 지정 후 segue 이동
            let destinationVC = segue.destination as! ItemListViewController
            destinationVC.drugBoxId = self.currentDrugbox!
        } else if segue.identifier == K.manageSegue.settingSegue {
            // setting 페이지에서 get api 호출에 필요한 data 넘겨줌
            let destinationVC = segue.destination as! BoxSettingViewController
            destinationVC.drugBoxId = self.currentDrugbox!
        }
    }
    
    //MARK: - GET api
    func getDrugBoxList() -> Void {
        let url = K.apiURL.GETboxListURL

        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success:
                print("성공")
                self.boxList = self.boxManager.parseJSON(response.data!)
                self.boxTableView.reloadData() // 저장한 data UI에 그려주기
            case .failure:
                print(response.error.debugDescription)
            }
        }
    }
}

//MARK: - TableView functions
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
        // segue call
        self.performSegue(withIdentifier: K.manageSegue.showItemSegue, sender: self)
        self.prepare(for: UIStoryboardSegue.init(identifier: K.manageSegue.showItemSegue, source: self, destination: ItemListViewController()), sender: self)
        
//        boxTableView.deselectRow(at: indexPath, animated: true) // 색 원상태로 복귀
    }
    
}

//MARK: - Button func In the Cell
extension DefaultBoxViewController: ButtonTappedDelegate {
    func cellButtonTapped(_ buttonTag: Int) {
        self.currentDrugbox = buttonTag
        self.performSegue(withIdentifier: K.manageSegue.settingSegue, sender: self)
    }
}

