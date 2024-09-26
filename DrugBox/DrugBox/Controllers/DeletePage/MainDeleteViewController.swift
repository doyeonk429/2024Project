//
//  MainDeleteViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit
import SnapKit
import SafariServices
import Then

class MainDeleteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let titleLabel = UILabel().then {
        $0.text = "폐의약품 처리 방법"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textAlignment = .left
        $0.textColor = UIColor(hex: "169F00")
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "거주 지역을 선택하여 자세한 정보를 확인하세요.(현재 서울시만 지원)"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    // Create the table view
    private let tableView = UITableView().then {
        $0.register(LabelTableViewCell.self, forCellReuseIdentifier: "LabelCell")
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }
    
    private let actionButton = UIButton(type: .system).then {
        $0.setTitle("내 폐의약품 확인하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(hex: "169F00")
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
    }
    
    // Extract keys from the dictionary for displaying in the table view
    private var keys: [String] {
        return Array(K.DeletePageURL.seoulDistricts.keys).sorted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)
        view.addSubview(actionButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
 
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(actionButton.snp.top).offset(-16)
        }
 
        actionButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as? LabelTableViewCell else {
            return UITableViewCell()
        }
        let key = keys[indexPath.row]
        cell.cellLabel.text = key
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = keys[indexPath.row]
        if let urlString = K.DeletePageURL.seoulDistricts[key], let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }

    
    @objc private func actionButtonPressed() {
        let infoView = InfoViewController()
        self.navigationController?.pushViewController(infoView, animated: true)
    }
    
}
