//
//  SettingMenuViewController.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit
import Moya
import SwiftyToaster
import SafariServices

class SettingMenuViewController: UIViewController {
    
    let Authprovider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin(), BearerTokenPlugin()])

    // Sample data for the table view
    private let menuItems = ["계정 정보", "알림 설정", "개인정보 처리방침", "로그아웃"]
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
    
    private func openWebPage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func showSplashScreen() {
        let splashViewController = LoginViewController()

        // 현재 윈도우 가져오기
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else {
            print("윈도우를 가져올 수 없습니다.")
            return
        }

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = splashViewController
        }, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension SettingMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
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
            Toaster.shared.makeToast("푸시 알림 설정 창은 준비 중입니다.")
        case 2:
            openWebPage(urlString: "https://wobbly-session-4ae.notion.site/1491b64c5f28801ebc1fc346082c6547?pvs=4")
        case 3:
            logOut()
        default:
            print("Error: ViewController not found.")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension SettingMenuViewController {
    func logOut() {
        guard let accessToken = LoginViewController.keychain.get("serverAccessToken") else {
            print("Access Token 없음")
            return
        }
        
        Authprovider.request(.postLogout(accessToken: accessToken)) { result in
            switch result {
            case .success(let response) :
                if response.statusCode == 200 {
                    LoginViewController.keychain.delete("serverAccessToken")
                    LoginViewController.keychain.delete("serverRefreshToken")
                    self.showSplashScreen()
                    Toaster.shared.makeToast("로그아웃")
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
            }
        }
        
    }
}
