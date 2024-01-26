//
//  MenuSelect.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class MenuSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = K.appName
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
        self.performSegue(withIdentifier: K.alarmSegue, sender: self)
    }
}
