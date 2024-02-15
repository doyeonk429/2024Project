//
//  ItemListViewController.swift
//  DrugBox
//
//  Created by 김도연 on 2/4/24.
// 약 리스트 페이지. 멀티 선택 가능한

import UIKit
import Alamofire

class ItemListViewController: UIViewController {
    @IBOutlet weak var DrugTableView: UITableView!
    @IBOutlet weak var AddNewDrugButton: UIBarButtonItem!
    @IBOutlet weak var UseDrugButton: UIButton!
    
    var Drugs : [DrugModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getDrugList(_ drugboxId: Int) {
        <#function body#>
    }
    
    func parseJSON(_ data: Data) -> <#return type#> {
        <#function body#>
    }
}

extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    
}
