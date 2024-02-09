//
//  MainDeleteViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class MainDeleteViewController: UIViewController {
    @IBOutlet weak var ContentsTableView: UITableView!
    
    var contents: [String] = ["폐의약품 분리배출", "서울권 지역 폐기 방법", "비서울권 지역 폐기 방법"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        ContentsTableView.delegate = self
        ContentsTableView.dataSource = self
        
        ContentsTableView.register(UINib(nibName:K.tableCell.contentCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.contentCellNibName)
        ContentsTableView.rowHeight = UITableView.automaticDimension
        ContentsTableView.estimatedRowHeight = UITableView.automaticDimension
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 28))
        header.backgroundColor = .systemBackground
        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.text = "   의약품 폐기 방법"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textAlignment = .left
        header.addSubview(headerLabel)
        
        ContentsTableView.tableHeaderView = header
    }
    
}

extension MainDeleteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contents[indexPath.row]
        let cell = ContentsTableView.dequeueReusableCell(withIdentifier: K.tableCell.contentCellNibName, for: indexPath) as! WayToDelete
        cell.TitleButton.setTitle(content, for: .normal)
        
        return cell
    }
    
}
