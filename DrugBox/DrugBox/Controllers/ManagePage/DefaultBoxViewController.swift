//
//  DefaultBoxViewController.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class DefaultBoxViewController: UIViewController {
    
    var boxList: [BoxModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.manageSegue.createSegue, sender: self)
    }
}
