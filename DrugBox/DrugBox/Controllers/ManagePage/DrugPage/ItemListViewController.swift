//
//  ItemListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/4/24.
// 약 리스트 페이지. 멀티 선택 가능한

import UIKit
import SnapKit
import Moya
import Then

class ItemListViewController: UIViewController {
    
    // Drugs 데이터 배열
    var Drugs: [DrugModel] = [
        DrugModel(boxId: 1, drugName: "테스트", drugCount: 10, location: "몰라", expDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 30)) ?? Date(), inDisposalList: false)
    ]
    
    // 선택된 drugBoxId
    var drugBoxId: Int?
    var drugBoxName: String?
    
    // 테이블뷰 생성
    let drugTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 하단 버튼 생성
    let useDrugButton = UIButton(type: .system).then {
        $0.setTitle("Use Drug", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // 네비게이션 바 설정
        self.title = drugBoxName ?? ""
        let addNewDrugButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDrugButtonTapped))
        self.navigationItem.rightBarButtonItem = addNewDrugButton
        
        // 뷰에 서브뷰 추가
        view.addSubview(drugTableView)
        view.addSubview(useDrugButton)
        
        // 레이아웃 설정
        setupLayout()
        
        // 테이블뷰 설정
        drugTableView.delegate = self
        drugTableView.dataSource = self
        drugTableView.register(DrugCell.self, forCellReuseIdentifier: "DrugCell")
        
        drugTableView.reloadData()
    }
    
    @objc func addNewDrugButtonTapped() {
        // SearchViewController를 모달로 표시
        let searchVC = SearchDrugViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 레이아웃 설정 함수
    func setupLayout() {
        // 테이블뷰 레이아웃
        drugTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.equalToSuperview().offset(10)             // 왼쪽과 10의 offset
            make.right.equalToSuperview().offset(-10)           // 오른쪽과 10의 offset
            make.height.greaterThanOrEqualTo(200)
        }
        
        // 버튼 레이아웃
        useDrugButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(drugTableView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)             // 왼쪽과 10의 offset
            make.right.equalToSuperview().offset(-10)           // 오른쪽과 10의 offset
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16) // Safe area의 하단과 10의 offset
        }
    }

}
//MARK: - TableView delegate Methods
extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath) as! DrugCell
        let drug = Drugs[indexPath.row]
        
        // DrugCell 데이터 설정
        cell.drugNameLabel.text = drug.drugName
        cell.drugCountLabel.text = "\(drug.drugCount)개"
        
        // CheckBoxDelegate 설정
        cell.delegate = self
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 약 상세 정보로 이동하도록 만들기
        //테이블뷰의 이벤트처리 함수
//        print("테이블뷰 셀이 클릭 되었다!")
        // segue call
//        self.performSegue(withIdentifier: K.manageSegue.showItemSegue, sender: self)
//        self.prepare(for: UIStoryboardSegue.init(identifier: K.manageSegue.showItemSegue, source: self, destination: ItemListViewController()), sender: self)
        
//        boxTableView.deselectRow(at: indexPath, animated: true) // 색 원상태로 복귀
    }
    
    
}

extension ItemListViewController: CheckBoxDelegate {
    func onCheck() {
        print("체크버튼 눌림)")
    }
}


struct DrugListData: Codable{
    let id: Int
    let name: String
    let count: Int
    let location: String
    let expDate: String
    let inDisposalList: Bool
}
