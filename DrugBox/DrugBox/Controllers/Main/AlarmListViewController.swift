//
//  AlarmListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class AlarmListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let dateformatter = DateFormatter()
    var alarms: [Alarm] = [
        Alarm(isUpdated: true, timestamp: "2024-01-27 12:20", alarmBody: "동백님이 구급상자1에 타이레놀 서방정을 추가하였습니다."),
        Alarm(isUpdated: false, timestamp: "2024-01-27 9:33", alarmBody: "구급상자1에 들어있는 부루펜의 사용 가능 기한이 1주일 남았습니다. 교체하세요!")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.tableCell.cellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.cellIdentifier)
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 28))
        header.backgroundColor = .systemBackground
        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.text = "    알림"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textAlignment = .left
        header.addSubview(headerLabel)
        
        tableView.tableHeaderView = header
    }


}
//MARK: - TableView 구현
extension AlarmListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 테이블 셀 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    // 테이블에 셀 정보 넣어줌
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = alarms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCell.cellIdentifier, for: indexPath) as! AlarmCell
        cell.TimestampLabel.text = alarm.timestamp
        cell.AlarmContentLabel.text = alarm.alarmBody
        
        if alarm.isUpdated == true {
            cell.alarmLightIcon.tintColor = UIColor.systemGreen
        } else {
            cell.alarmLightIcon.tintColor = UIColor.lightGray
        }
        
        return cell
    }
    
    // 옆으로 스와이프해서 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alarms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
