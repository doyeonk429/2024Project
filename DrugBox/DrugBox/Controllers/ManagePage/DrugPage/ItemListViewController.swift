//
//  ItemListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/4/24.
// 약 리스트 페이지. 멀티 선택 가능한

import UIKit
import SnapKit
import Moya
import Then
import SwiftyToaster

class ItemListViewController: UIViewController {
    
    let provider = MoyaProvider<DrugService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    // Drugs 데이터 배열
    var Drugs: [DrugModel] = []
    var drugsInfo : [Int :drugInfoData] = [:]
    var useDrug : [Int] = []
    
    // 선택된 drugBoxId
    var drugBoxId: Int?
    var drugBoxName: String?
    
    // 테이블뷰 생성
    let drugTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 하단 버튼 생성
    let useDrugButton = UIButton(type: .system).then {
        $0.setTitle("약 사용하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appGreen // 배경색 설정
        $0.setTitleColor(.white, for: .normal) // 텍스트 색상 설정 (필요 시)
        $0.layer.cornerRadius = 8 // 모서리 둥글게 (옵션)
        $0.layer.masksToBounds = true // 둥근 모서리 효과 적용
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // 네비게이션 바 설정
        self.title = drugBoxName ?? ""
        let addNewDrugButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDrugButtonTapped))
        self.navigationItem.rightBarButtonItem = addNewDrugButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        useDrugButton.addTarget(self, action: #selector(useDrugButtonTapped), for: .touchUpInside)
        setupTableView()
        setupLayout()
        
        callGetDrugs { isSuccess in
            if isSuccess {
                self.drugTableView.reloadData()
            } else {
                print("의약품 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callGetDrugs { isSuccess in
            if isSuccess {
                self.drugTableView.reloadData()
            } else {
                print("의약품 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
        
        if let selectedIndexPath = drugTableView.indexPathForSelectedRow {
            drugTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func setupTableView() {
        drugTableView.delegate = self
        drugTableView.dataSource = self
        drugTableView.separatorStyle = .singleLine
        drugTableView.register(DrugCell.self, forCellReuseIdentifier: "DrugCell")

        view.addSubview(drugTableView)
    }
    
    func setupLayout() {
        view.addSubview(useDrugButton)

        drugTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        useDrugButton.snp.makeConstraints { make in
            make.top.equalTo(drugTableView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    @objc func addNewDrugButtonTapped() {
        let searchVC = SearchDrugViewController()
        searchVC.currentBoxId = self.drugBoxId
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func useDrugButtonTapped() {
        guard let boxid = self.drugBoxId else { return }
        
        callPatchAPI(requestData: setupUseData(boxId: boxid, drugIds: self.useDrug)) { isSuccess in
            if isSuccess {
                self.callGetDrugs { isSuccess in
                    if isSuccess {
                        self.drugTableView.reloadData()
                    } else {
                        print("패치 후, 의약품 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
                    }
                }
            } else {
                print("패치 호출 실패 - 다시 시도해주세요.")
            }
        }
    }
    
    func setupUseData(boxId : Int, drugIds: [Int]) -> DrugUpdateRequest {
        return DrugUpdateRequest(drugIds: drugIds, drugboxId: boxId)
    }
    
    func callPatchAPI(requestData: DrugUpdateRequest, completion : @escaping (Bool) -> Void) {
        print(requestData)
        provider.request(.patchDrugs(data: requestData)) { result in
            switch result {
            case .success(let response):
                completion(true)
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    func callGetDrugs(completion: @escaping (Bool) -> Void) {
        if let id = self.drugBoxId {
            provider.request(.getDrugs(boxId: id)) { result in
                switch result {
                case .success(let response) :
                    do {
                        self.Drugs = []
                        let responseData = try response.map([DrugDetailResponse].self)
                        for drugData in responseData {
                            for drug in drugData.drugResponses {
                                let drugModel = DrugModel(id : drug.id, drugName: drug.name, drugCount: drug.count, location: drug.location, expDate: drug.expDate, inDisposalList: drug.inDisposalList)
                                if !drugModel.inDisposalList {
                                    self.Drugs.append(drugModel)
                                }
                                // drugID : [이름, 효과]
                                self.drugsInfo[drug.id] = drugInfoData(name: drugData.name, effect: drugData.effect)
                            }
                        }
                        completion(true)
                    } catch {
                        print("Failed to decode response: \(error)")
                        completion(false)
                    }
                case .failure(let error) :
                    if let response = error.response {
                        Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                    }
                    completion(false)
                }
            }
        }
    }

}
//MARK: - TableView delegate Methods
extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath) as! DrugCell
        let drug = Drugs[indexPath.row]
        
        cell.configure(name: drug.drugName, count: drug.drugCount, id: drug.id)
        cell.delegate = self
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDrug = Drugs[indexPath.row]
        let drugId = selectedDrug.id
        let drugDetailVC = ShowDrugDetailViewController()
        drugDetailVC.boxId = drugBoxId
        drugDetailVC.drugDetail = selectedDrug
        if drugsInfo.keys.contains(drugId) {
            drugDetailVC.drugName = drugsInfo[drugId]?.name
            drugDetailVC.drugEffect = drugsInfo[drugId]?.effect
        }
        
        self.navigationController?.pushViewController(drugDetailVC, animated: true)
    }

}

extension ItemListViewController: CheckBoxDelegate {
    func onCheck(drugId: Int) {
        useDrug.append(drugId)
    }
}


struct DrugListData: Codable {
    let id: Int
    let name: String
    let count: Int
    let location: String
    let expDate: String
    let inDisposalList: Bool
}

struct drugInfoData {
    let name : String
    let effect : String
}
