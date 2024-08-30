//
//  SearchDrugViewController.swift
//  DrugBox
//
//  Created by 김도연 on 8/30/24.
//

import UIKit
import SnapKit
import Then

class SearchDrugViewController : UIViewController {
    
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
    let searchBar = UISearchBar().then {
        $0.placeholder = "약 이름을 입력하세요"
        $0.showsCancelButton = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상 설정
        view.backgroundColor = .white
        
        // 서브뷰 추가
        view.addSubview(titleLabel)
        view.addSubview(xButton)
        view.addSubview(searchBar)
        
        // UISearchBarDelegate 설정
        searchBar.delegate = self
        
        // 레이아웃 설정
        setTitleLabelUI()
        setSearchBarUI()
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
        
        // UISearchBarDelegate 설정
        searchBar.delegate = self
    }
    
    // 닫기 버튼 액션
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchDrugViewController : UISearchBarDelegate {
    // 검색 버튼 클릭 시 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        // 검색 실행 (예: 콘솔에 출력)
        print("검색어: \(searchText)")
        
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
