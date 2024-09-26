//
//  AlarmListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit
import SnapKit
import Then

class AlarmListViewController: UIViewController {

    // Title label
    private let titleLabel = UILabel().then {
        $0.text = "알림"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    // Table view
    private let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .systemBackground
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }

    private let dateformatter = DateFormatter()
    
    var alarms: [Alarm] = [
        Alarm(isUpdated: true, timestamp: "2024-01-27 12:20", alarmBody: "동백님이 구급상자1에 타이레놀 서방정을 추가하였습니다."),
        Alarm(isUpdated: false, timestamp: "2024-01-27 9:33", alarmBody: "구급상자1에 들어있는 부루펜의 사용 가능 기한이 1주일 남았습니다. 교체하세요!")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        // Set up the title label constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Set up the table view constraints
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        // Set delegates and register cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmCell.self, forCellReuseIdentifier: K.tableCell.cellIdentifier)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AlarmListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCell.cellIdentifier, for: indexPath) as? AlarmCell else {
            return UITableViewCell()
        }

        let alarm = alarms[indexPath.row]
        cell.TimestampLabel.text = alarm.timestamp
        cell.AlarmContentLabel.text = alarm.alarmBody
        cell.alarmLightIcon.tintColor = alarm.isUpdated ? .systemGreen : .lightGray
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alarms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
