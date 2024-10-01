//
//  InfoViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/3/24.
//

import UIKit
import SnapKit
import Then

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myMedList: [String: [MedInfo]] = [
        "test-01": [
            MedInfo(name: "Drug 01", count: 3),
            MedInfo(name: "Drug 02", count: 98),
            MedInfo(name: "Drug 03", count: 100)
        ],
        "test-003": [
            MedInfo(name: "Drugs 01", count: 33),
            MedInfo(name: "Drugs 02", count: 928),
            MedInfo(name: "Drugs 03", count: 10),
            MedInfo(name: "Drugs 04", count: 109),
        ]
    ]
    
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
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myMedList.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(myMedList.keys)[section]
        return myMedList[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(myMedList.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DisposalDrugCell", for: indexPath) as? DisposalDrugCell else {
            return UITableViewCell()
        }
        
        let sectionKey = Array(myMedList.keys)[indexPath.section]
        if let medInfo = myMedList[sectionKey]?[indexPath.row] {
            cell.firstLabel.text = medInfo.name
            cell.secondLabel.text = "\(medInfo.count)"
        }
        
        // Update checkbox image based on selection state
        cell.checkboxImageView.image = selectedIndexPaths.contains(indexPath) ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        cell.checkboxImageView.tintColor = selectedIndexPaths.contains(indexPath) ? UIColor(hex: "169F00") : .gray
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
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPaths.remove(indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Dispose Button Action
    
    @objc private func disposeButtonTapped() {
        // Iterate over the selected index paths and remove the items
        for indexPath in selectedIndexPaths.sorted(by: { $0.section > $1.section || ($0.section == $1.section && $0.row > $1.row) }) {
            let sectionKey = Array(myMedList.keys)[indexPath.section]
            myMedList[sectionKey]?.remove(at: indexPath.row)
            
            // If the section becomes empty, remove the section from myMedList
            if myMedList[sectionKey]?.isEmpty == true {
                myMedList.removeValue(forKey: sectionKey)
            }
        }
        
        // Clear the selected index paths set
        selectedIndexPaths.removeAll()
        
        // Reload the table view to reflect the changes
        tableView.reloadData()
    }
    
}
// MARK: - MedInfo Struct

struct MedInfo {
    let name: String
    let count: Int
}
