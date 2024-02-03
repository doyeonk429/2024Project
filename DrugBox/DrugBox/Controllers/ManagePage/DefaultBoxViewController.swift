//
//  DefaultBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class DefaultBoxViewController: UIViewController {
    
    // get으로 받아온 박스모델 여기에 추가
    // 테이블 뷰 구현해야함
    // 테이블 셀 선택 시 해당 구급상자 내의 알약 정보 get 해서 다음 페이지에 넘겨주기
    var boxList: [BoxModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
}
