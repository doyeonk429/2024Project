//
//  InfoViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/3/24.
//

import UIKit
import SnapKit
import Then
import Moya
import SwiftyToaster

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let provider = MoyaProvider<DrugService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    var myMedList: [boxInfo: [MedInfo]] = [:]
    
    var selectedIndexPaths: Set<IndexPath> = []
    
    private let titleLabel = UILabel().then {
        $0.text = "내 폐의약품 목록"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textAlignment = .left
        $0.textColor = UIColor(hex: "169F00")
    }
    
    private let tableView = UITableView().then {
        $0.register(DisposalDrugCell.self, forCellReuseIdentifier: "DisposalDrugCell")
        $0.separatorStyle = .singleLine
        $0.allowsMultipleSelection = true // Enable multi-selection
    }
    
    private let disposeButton = UIButton(type: .system).then {
        $0.setTitle("폐기하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(hex: "169F00")
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(disposeButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupUI()
        
        callGetList { isSuccess in
            if isSuccess {
                self.tableView.reloadData()
            } else {
                print("데이터 불러오기 실패")
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(disposeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(disposeButton.snp.top).offset(-16)
        }
        
        disposeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpDeleteData(_ boxId: Int, _ drugId: [Int]) -> DrugUpdateRequest {
        return DrugUpdateRequest(drugIds: drugId, drugboxId: boxId)
    }
    
    func callDelete(data : [DrugUpdateRequest] , completion : @escaping (Bool) -> Void) {
        provider.request(.deleteDisposal(data: data)) { result in
            switch result {
            case .success(let response) :
                print("삭제 성공 !")
                completion(true)
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    func callGetList(completion : @escaping (Bool) -> Void) {
        provider.request(.getDisposalList) { result in
            switch result {
            case .success(let response) :
                do {
                    let reponseData = try response.map([DisposalResponse].self)
                    self.myMedList.removeAll()
                    for boxData in reponseData {
                        let box = boxInfo(boxId: boxData.drugboxId, boxName: boxData.drugboxName)
                        self.myMedList[box] = []
                        for drugs in boxData.drugResponses {
                            let drug = MedInfo(id: drugs.id, name: drugs.name, count: drugs.count, date: drugs.expDate)
                            self.myMedList[box]?.append(drug)
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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myMedList.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(myMedList.keys)[section]
        return myMedList[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKey = Array(myMedList.keys)[section]
        
        // 섹션 데이터가 비어 있으면 nil 반환
        if let sectionData = myMedList[sectionKey], sectionData.isEmpty {
            return nil
        }
        
        // 데이터가 있으면 섹션 이름 반환
        return sectionKey.boxName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DisposalDrugCell", for: indexPath) as? DisposalDrugCell else {
            return UITableViewCell()
        }
        
        let sectionKey = Array(myMedList.keys)[indexPath.section]
        if let medInfo = myMedList[sectionKey]?[indexPath.row] {
            cell.configure(medInfo.name, medInfo.count, medInfo.date)
        }
        
        cell.checkboxImageView.image = selectedIndexPaths.contains(indexPath) ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        cell.checkboxImageView.tintColor = selectedIndexPaths.contains(indexPath) ? .appGreen : .appGrey
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedIndexPaths.remove(indexPath)
        } else {
            selectedIndexPaths.insert(indexPath)
        }
        
        // Reload the specific row to update the checkbox appearance
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPaths.remove(indexPath)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - Dispose Button Action
    
    @objc private func disposeButtonTapped() {
        // Iterate over the selected index paths and remove the items
        var requestLists : [DrugUpdateRequest] = []
        var tempDatas : [Int: [Int]] = [:]
        for indexPath in selectedIndexPaths.sorted(by: { $0.section > $1.section || ($0.section == $1.section && $0.row > $1.row) }) {
            let sectionKey = Array(myMedList.keys)[indexPath.section]
            
            if let sectionData = myMedList[sectionKey] {
                let selectedMed = sectionData[indexPath.row] // 선택된 행의 MedInfo
//                print("섹션: \(sectionKey.boxId), 선택된 약 정보: \(selectedMed.id)")
                if tempDatas[sectionKey.boxId] == nil {
                    tempDatas[sectionKey.boxId] = [selectedMed.id]
                } else {
                    tempDatas[sectionKey.boxId]?.append(selectedMed.id)
                }
            }
        }
        for (boxId, drugIds) in tempDatas {
            let data = setUpDeleteData(boxId, drugIds)
            requestLists.append(data)
        }
        
        print(requestLists)
        
        callDelete(data: requestLists) { isSucces in
            if isSucces {
                print("데이터 다시 콜")
                self.callGetList { isSuccess in
                    if isSuccess {
                        self.tableView.reloadData()
                    } else {
                        print("데이터 불러오기 실패")
                    }
                }
            } else {
                print("데이터 삭제 못함")
            }
        }

    }
    
}
// MARK: - MedInfo Struct

struct MedInfo {
    let id: Int
    let name: String
    let count: Int
    let date: String
}

struct boxInfo : Hashable {
    let boxId: Int
    let boxName: String
}
