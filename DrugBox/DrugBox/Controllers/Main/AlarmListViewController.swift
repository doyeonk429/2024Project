//
//  AlarmListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class AlarmListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var alarms: [Alarm] = [
        Alarm(isUpdated: true, timestamp: Date(), alarmBody: "동백님이 구급상자1에 타이레놀 서방정을 추가하였습니다.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        self.tableView.estimatedRowHeight = 105.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }


}

extension AlarmListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = alarms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! AlarmCell
        cell.TimestampLabel.text = DateFormatter().string(from: alarm.timestamp)
        cell.AlarmContentLabel.text = alarm.alarmBody
        
        if alarm.isUpdated == true {
            cell.alarmLightIcon.tintColor = UIColor.systemGreen
        } else {
            cell.alarmLightIcon.tintColor = UIColor.lightGray
        }
        
        return cell
    }
    
}
