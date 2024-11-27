//
//  DrugSearchByLabelViewController.swift
//  DrugBox
//
//  Created by 김도연 on 11/20/24.
//

import UIKit
import SnapKit
import SDWebImage

class DrugSearchByLabelViewController: UIViewController {
    
    // OCR 결과 데이터
    public var ocrSearchStringList: [PillData] = []

    // 테이블뷰 생성
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PillTableViewCell.self, forCellReuseIdentifier: PillTableViewCell.identifier)
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "검색 결과"
        
        // 테이블뷰 설정
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
}

extension DrugSearchByLabelViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 테이블 뷰의 섹션당 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ocrSearchStringList.count
    }
    
    // 각 셀의 내용 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PillTableViewCell.identifier, for: indexPath) as? PillTableViewCell else {
            return UITableViewCell()
        }
        let pill = ocrSearchStringList[indexPath.row]
        cell.configure(with: pill)
        return cell
    }
}
