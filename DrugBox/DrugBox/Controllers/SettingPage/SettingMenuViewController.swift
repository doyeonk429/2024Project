//
//  SettingMenuViewController.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit

class SettingMenuViewController: UIViewController {

    // Sample data for the table view
    private let menuItems = ["계정 정보", "알림 설정", "개인 정보 제공 동의"]
    private let menuPages = ["UserSettingViewController", "NotificationSettingViewController", "PrivacyInfoViewController"]

    // Custom view of the view controller (MenuView)
    private lazy var menuView: MenuView = {
        let view = MenuView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.view = menuView
        
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
    }
    
}

// MARK: - UITableViewDataSource

extension SettingMenuViewController: UITableViewDataSource {
    
    // Number of sections (usually 1 unless there's grouping)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in the section (menuItems count)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    // Provide a cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Using the basic style of UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Set the textLabel (this is the default UILabel provided by UITableViewCell)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)  // Optional: Customize font size
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let nextViewController = UserSettingViewController()
            navigationController?.pushViewController(nextViewController, animated: true)
        case 1:
            let nextViewController = NotificationSettingViewController()
            navigationController?.pushViewController(nextViewController, animated: true)
        case 2:
            let nextViewController = PrivacyInfoViewController()
            navigationController?.pushViewController(nextViewController, animated: true)
        default:
            print("Error: ViewController not found.")
            
        }
        
        // Deselect the selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

