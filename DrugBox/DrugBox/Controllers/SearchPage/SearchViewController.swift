//
//  SearchViewController.swift
//  DrugBox
//
//  Created by 김도연 on 10/1/24.
//

import UIKit
import SwiftyToaster

class SearchViewController : UIViewController, UISearchBarDelegate {
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "Search for places"
        $0.showsCancelButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Hide the keyboard
        Toaster.shared.makeToast("검색 기능은 잠시 중단되었습니다.")
    }
    
}
