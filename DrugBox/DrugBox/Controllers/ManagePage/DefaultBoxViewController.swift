//
//  DefaultBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit
import Alamofire
import Moya

class DefaultBoxViewController: UIViewController {
    
    @IBOutlet weak var boxTableView: UITableView!
    var boxManager = BoxManager() // json data parsing functions
    var currentDrugbox : Int? // 선택한 drugbox의 id 저장 변수
    
    //MARK: - API provider
    let provider = MoyaProvider<BoxManageService>(plugins: [BearerTokenPlugin()])
    
    // 테이블 셀 선택 시 해당 구급상자 내의 알약 정보 get 해서 다음 페이지에 넘겨주기

    var boxList: [BoxListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boxTableView.delegate = self
        boxTableView.dataSource = self
        boxTableView.register(UINib(nibName: K.tableCell.boxCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.boxCellIdentifier)
        
        callGetBoxList { isSucess in
            if isSucess {
//                print("박스 개수 : \(self.boxList.count)")
                self.boxTableView.reloadData()
            } else {
                print("구급상자 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 뷰 갓다와서 업데이트할 건 여기다가
        
        // 다시 화면으로 돌아왔을 때 선택 해제
        if let selectedIndexPath = boxTableView.indexPathForSelectedRow {
            boxTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
    
    //MARK: - Segue prepare
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.manageSegue.showItemSegue {
//            // drug 리스트 api 불러오는데 필요한 drugbox number 변수값 지정 후 segue 이동
//            let destinationVC = segue.destination as! ItemListViewController
//            destinationVC.drugBoxId = self.currentDrugbox!
//        } else if segue.identifier == K.manageSegue.settingSegue {
//            // setting 페이지에서 get api 호출에 필요한 data 넘겨줌
//            let destinationVC = segue.destination as! BoxSettingViewController
//            destinationVC.drugBoxId = self.currentDrugbox!
//        }
//    }
    
    //MARK: - GET api
    func callGetBoxList(completion: @escaping (Bool) -> Void) {
        provider.request(.getBoxes) { result in
            switch result {
            case .success(let response) :
                do {
                    let responseData = try response.map([DrugBoxResponse].self)
//                    print(responseData)
//                    print("-----------------------------")
                    for boxData in responseData {
                        let tempbox = BoxListModel(name: boxData.name, drugboxId: boxData.drugboxId, imageURL: boxData.image)
                        self.boxList.append(tempbox)
                    }
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
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
        // 선택된 셀의 데이터를 가져오기
        let selectedBox = boxList[indexPath.row]
        self.currentDrugbox = selectedBox.drugboxId
        
        let itemListVC = ItemListViewController()
        itemListVC.drugBoxId = selectedBox.drugboxId
        itemListVC.drugBoxName = selectedBox.name
        self.navigationController?.pushViewController(itemListVC, animated: true)
        
//        // segue call
//        self.performSegue(withIdentifier: K.manageSegue.showItemSegue, sender: self)
//        self.prepare(for: UIStoryboardSegue.init(identifier: K.manageSegue.showItemSegue, source: self, destination: ItemListViewController()), sender: self)
    }
    
}

//MARK: - Button func In the Cell
extension DefaultBoxViewController: ButtonTappedDelegate {
    func cellButtonTapped(_ buttonTag: Int) {
        let settingVC = BoxSettingViewController()
        settingVC.drugBoxId = self.currentDrugbox
        self.navigationController?.pushViewController(settingVC, animated: true)
//        self.performSegue(withIdentifier: K.manageSegue.settingSegue, sender: self)
    }
}

