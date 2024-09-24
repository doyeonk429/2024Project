//
//  DefaultBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit
import Alamofire
import Moya

class DefaultBoxViewController: UIViewController {
    
    @IBOutlet weak var boxTableView: UITableView!
    var boxManager = BoxManager() // json data parsing functions
    var currentDrugbox : Int? // 선택한 drugbox의 id 저장 변수
    
    //MARK: - API provider
//    let provider = MoyaProvider<BoxManageService>(plugins: [BearerTokenPlugin()])
    let provider = MoyaProvider<BoxManageService>(plugins: [
        BearerTokenPlugin(),
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    // 테이블 셀 선택 시 해당 구급상자 내의 알약 정보 get 해서 다음 페이지에 넘겨주기

    var boxList: [BoxListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boxTableView.delegate = self
        boxTableView.dataSource = self
        boxTableView.register(UINib(nibName: K.tableCell.boxCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCell.boxCellIdentifier)
        
        callGetBoxList { isSucess in
            if isSucess {
                self.boxTableView.reloadData()
            } else {
                print("구급상자 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 뷰 갓다와서 업데이트할 건 여기다가
        callGetBoxList { isSucess in
            if isSucess {
                self.boxTableView.reloadData()
            } else {
                print("구급상자 목록을 불러오는데 실패했습니다.\n다시 시도해주세요.")
            }
        }
        
        // 다시 화면으로 돌아왔을 때 선택 해제
        if let selectedIndexPath = boxTableView.indexPathForSelectedRow {
            boxTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
    
    //MARK: - GET api
    
//    func callGetBox() -> [BoxListModel] {
//        var boxList = [BoxListModel]()
//        provider.request(.getBoxes) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let responseData = try response.map([DrugBoxResponse].self)
//                    for boxData in responseData {
//                        let tempbox = BoxListModel(name: boxData.name, drugboxId: boxData.drugboxId, imageURL: boxData.image)
//                        boxList.append(tempbox)
//                    }
//                } catch {
//                    print("failed")
//                }
//            case .failure(let error) :
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//        print(boxList)
//        return boxList
//    }
    
    func callGetBoxList(completion: @escaping (Bool) -> Void) {
        provider.request(.getBoxes) { result in
            switch result {
            case .success(let response) :
//                print(response.statusCode)
                if response.statusCode == 200 {
                    do {
                        self.boxList = []
                        let responseData = try response.map([DrugBoxResponse].self)
                        for boxData in responseData {
                            let tempbox = BoxListModel(name: boxData.name, drugboxId: boxData.drugboxId, imageURL: boxData.image)
                            self.boxList.append(tempbox)
                        }
                    } catch {
                        print("Failed to decode response: \(error)")
                        completion(false)
                    }
                    completion(true)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

//MARK: - TableView functions
extension DefaultBoxViewController: UITableViewDataSource, UITableViewDelegate {
    // 테이블 셀 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let box = boxList[indexPath.row]
        
        let cell = boxTableView.dequeueReusableCell(withIdentifier: "BoxCell", for: indexPath) as! BoxCell
        
        cell.BoxNameLabel.text = " \(box.name)"
        if let url = URL(string: box.imageURL) {
            cell.boxImage.loadImage(url: url)
//            cell.boxImage.image = UIImage(systemName: K.drugboxDefaultImage)
//            print(url)
        } else {
            cell.boxImage.image = UIImage(systemName: K.drugboxDefaultImage)
        }
        cell.drugboxId = box.drugboxId
        cell.SettingButton.tag = box.drugboxId
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //테이블뷰의 이벤트처리 함수
        // 선택된 셀의 데이터를 가져오기
        let selectedBox = boxList[indexPath.row]
        self.currentDrugbox = selectedBox.drugboxId
        
        let itemListVC = ItemListViewController()
        itemListVC.drugBoxId = selectedBox.drugboxId
        itemListVC.drugBoxName = selectedBox.name
        self.navigationController?.pushViewController(itemListVC, animated: true)
    }
    
}

//MARK: - Button func In the Cell
extension DefaultBoxViewController: ButtonTappedDelegate {
    func cellButtonTapped(_ buttonTag: Int) {
        print("currentDrugbox in cellButtonTapped: \(currentDrugbox ?? -1) 태그는 \(buttonTag)")
        
        let settingVC = BoxSettingViewController()
//        settingVC.drugBoxId = self.currentDrugbox
        settingVC.drugBoxId = buttonTag
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}


//class boxCell: UITableViewCell {
//    
//    // UI 요소 생성
//    let boxImage = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.clipsToBounds = true
//    }
//    
//    let boxNameLabel = UILabel().then {
//        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        $0.textColor = .black
//    }
//    
//    let settingButton = UIButton(type: .system).then {
//        $0.setImage(UIImage(systemName: "gear"), for: .normal)
//        $0.tintColor = .systemBlue
//        $0.addTarget(self, action: #selector(settingButtonPressed(_:)), for: .touchUpInside)
//    }
//    
//    var drugboxId: Int = 0
//    
//    weak var delegate: ButtonTappedDelegate?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        // UI 요소를 contentView에 추가
//        contentView.addSubview(boxNameLabel)
//        contentView.addSubview(settingButton)
//        contentView.addSubview(boxImage)
//        
//        // SnapKit을 사용하여 레이아웃 설정
//        setupLayout()
//        
//        // 셀 스타일 설정
//        contentView.layer.borderWidth = 2
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.cornerRadius = 10
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupLayout() {
//        // boxNameLabel 레이아웃 설정
//        boxNameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalTo(settingButton.snp.leading).offset(-10)
//        }
//        
//        // settingButton 레이아웃 설정
//        settingButton.snp.makeConstraints { make in
//            make.centerY.equalTo(boxNameLabel.snp.centerY)
//            make.trailing.equalToSuperview().offset(-10)
//            make.width.height.equalTo(24)
//        }
//        
//        // boxImage 레이아웃 설정
//        boxImage.snp.makeConstraints { make in
//            make.top.equalTo(boxNameLabel.snp.bottom).offset(10)
//            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-10)
//            make.bottom.equalToSuperview().offset(-10)
//        }
//    }
//    
//    @objc func settingButtonPressed(_ sender: UIButton) {
//        delegate?.cellButtonTapped(drugboxId)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10, bottom: 10, right: 10))
//    }
//}
