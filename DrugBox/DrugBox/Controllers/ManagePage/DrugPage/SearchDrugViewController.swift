//
//  SearchDrugViewController.swift
//  DrugBox
//
//  Created by 김도연 on 8/30/24.
//

import UIKit
import SnapKit
import Then
import Moya

class SearchDrugViewController : UIViewController, UISearchBarDelegate {
    
    let provider = MoyaProvider<DrugService>(plugins: [BearerTokenPlugin()])
    var searchResultList = [String]()
    
    // 제목 라벨
    let titleLabel = UILabel().then {
        $0.text = "물품 추가하기"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    // 닫기 버튼
    let xButton = UIButton().then {
        $0.setTitle("X", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // UISearchBar 생성
    lazy var searchBar: UISearchBar = {
        let s = UISearchBar()
        s.delegate = self
        //경계선 제거
        s.searchBarStyle = .minimal
        s.layer.cornerRadius = 8
        s.layer.masksToBounds = true
        
        if let searchIcon = UIImage(named: "icon_search") {
            s.setImage(searchIcon, for: .search, state: .normal)
        }
        if let textField = s.value(forKey: "searchField") as? UITextField {
            // Placeholder 텍스트 속성 설정
            let placeholderText = "약 이름을 검색하세요"
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0.45, alpha: 1.0), // 색상 설정
                .font: UIFont.boldSystemFont(ofSize: 12) // 크기 설정
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
        s.searchTextField.backgroundColor = UIColor(hex: "#E5E5E5")
        
        return s
    }()
    
    // TableView 추가
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 50
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상 설정
        view.backgroundColor = .white
        
        // 서브뷰 추가
        view.addSubview(titleLabel)
        view.addSubview(xButton)
        view.addSubview(searchBar)
        view.addSubview(tableView) // TableView 추가
        
        // UISearchBarDelegate 설정
        searchBar.delegate = self
        
        // TableView Delegate & DataSource 설정
        tableView.delegate = self
        tableView.dataSource = self
        
        // 레이아웃 설정
        setTitleLabelUI()
        setSearchBarUI()
        setTableViewUI() // TableView 레이아웃 설정
    }
    
    private func setTitleLabelUI() {
        // 타이틀 라벨 레이아웃
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }

        // 닫기 버튼 레이아웃
        xButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
    }
    
    private func setSearchBarUI() {
        // SnapKit으로 오토레이아웃 설정
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

    }
    
    private func setTableViewUI() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // 닫기 버튼 액션
    @objc func closeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func callGetSearchResult(keyword: String, completion : @escaping (Bool) -> Void) {
        provider.request(.getSearchResult(name: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let drugStringList = try response.map([String].self)
                    self.searchResultList = drugStringList
                    DispatchQueue.main.async {
                        self.tableView.reloadData() // 검색 결과를 테이블뷰에 업데이트
                    }
                    completion(true)
                } catch {
                    print("map data error : \(error)")
                    completion(false)
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
    
    // 검색 버튼 클릭 시 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        // 검색 실행 (예: 콘솔에 출력)
//        print("검색어: \(searchText)")
        self.callGetSearchResult(keyword: searchText) { isSuccess in
            if isSuccess {
                for (idx, drug) in self.searchResultList.enumerated() {
                    print("약 \(idx) : \(drug)")
                }
            } else {
                print("다시 검색어를 입력하세요")
            }
        }
        
        // 키보드 닫기
        searchBar.resignFirstResponder()
    }
    
    // 취소 버튼 클릭 시 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 검색 바 초기화
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}

extension SearchDrugViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션당 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }

    // 각 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = searchResultList[indexPath.row] // 검색 결과 텍스트 설정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = .black
        return cell
    }
    
    // 셀 클릭 시 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDrug = searchResultList[indexPath.row]
        print("선택된 약: \(selectedDrug)")
        let addNewDrugVC = AddDrugViewController()
        addNewDrugVC.drugName = selectedDrug
        print("전달된 drugName: \(addNewDrugVC.drugName ?? "없음")")
        self.navigationController?.pushViewController(addNewDrugVC, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
