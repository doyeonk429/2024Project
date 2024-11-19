//
//  DrugBoxListVC.swift
//  DrugBox
//
//  Created by 김도연 on 11/10/24.
//

import UIKit
import SnapKit
import Moya

class DrugBoxListVC: UIViewController {
    
    var boxTableView: UITableView!
    lazy var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
    
    var boxManager = BoxManager() // json data parsing functions
    var currentDrugbox: Int? // 선택한 drugbox의 id 저장 변수
    
    // API provider with logging
    let provider = MoyaProvider<BoxManageService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    var boxList: [BoxListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        // Set up table view
        setupTableView()
        
        // Load data from API
        callGetBoxList { isSuccess in
            if isSuccess {
                self.boxTableView.reloadData()
            } else {
                print("구급상자 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
    }
    
    func setupTableView() {
        boxTableView = UITableView()
        boxTableView.delegate = self
        boxTableView.dataSource = self
        boxTableView.estimatedRowHeight = 162
        boxTableView.separatorStyle = .singleLine
        boxTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        // Register cell - change to the correct cell class
        boxTableView.register(NewBoxCell.self, forCellReuseIdentifier: "NewBoxCell")
        
        // Add table view to the view hierarchy and set layout
        view.addSubview(boxTableView)
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch data when the view reappears
        callGetBoxList { isSuccess in
            if isSuccess {
                self.boxTableView.reloadData()
            } else {
                print("구급상자 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
        
        // Deselect any selected row when view reappears
        if let selectedIndexPath = boxTableView.indexPathForSelectedRow {
            boxTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func setLayout() {
        boxTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func addButtonTapped() {
        let vc = CreateNewBoxViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callGetBoxList(completion: @escaping (Bool) -> Void) {
        provider.request(.getBoxes) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        self.boxList = []
                        let responseData = try response.map([DrugBoxResponse].self)
                        for boxData in responseData {
                            let tempBox = BoxListModel(name: boxData.name, drugboxId: boxData.drugboxId, imageURL: boxData.image)
                            self.boxList.append(tempBox)
                        }
                        completion(true)
                    } catch {
                        print("Failed to decode response: \(error)")
                        completion(false)
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

//MARK: - TableView Delegate & DataSource
extension DrugBoxListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let box = boxList[indexPath.row]
        
        // Dequeue cell and configure it
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewBoxCell", for: indexPath) as! NewBoxCell
        cell.configure(with: URL(string: box.imageURL), name: box.name, id: box.drugboxId)
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
        let selectedBox = boxList[indexPath.row]
        currentDrugbox = selectedBox.drugboxId
        
        let itemListVC = ItemListViewController()
        itemListVC.drugBoxId = selectedBox.drugboxId
        itemListVC.drugBoxName = selectedBox.name
        navigationController?.pushViewController(itemListVC, animated: true)
    }
}

//MARK: - Button Delegate in the Cell
extension DrugBoxListVC: ButtonTappedDelegate {
    func cellButtonTapped(_ buttonTag: Int) {
        print("currentDrugbox in cellButtonTapped: \(currentDrugbox ?? -1) 태그는 \(buttonTag)")
        
        let settingVC = BoxSettingViewController()
        settingVC.drugBoxId = buttonTag
        navigationController?.pushViewController(settingVC, animated: true)
    }
}
