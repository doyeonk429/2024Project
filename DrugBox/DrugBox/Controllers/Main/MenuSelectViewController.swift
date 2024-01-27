//
//  MenuSelect.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class MenuSelectViewController: UIViewController {
    
    @IBOutlet weak var manageButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let height: CGFloat = 80
            let bounds = self.navigationController!.navigationBar.bounds
            self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        let titleLabel = UILabel()
        titleLabel.text = "   DrugBox"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        
        // Do any additional setup after loading the view.
    }


    @IBAction func alarmButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.mainSegue.alarmSegue, sender: self)
    }
    
    
    @IBAction func manageButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.mainSegue.manageSegue, sender: self)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.mainSegue.deleteSegue, sender: self)
    }
    

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.mainSegue.searchSegue, sender: self)
    }
}
