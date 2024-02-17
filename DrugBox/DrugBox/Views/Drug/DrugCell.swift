//
//  DrugCell.swift
//  DrugBox
//
//  Created by 김도연 on 2/18/24.
//

import UIKit

class DrugCell: UITableViewCell {
    
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var DrugCountLabel: UILabel!
    @IBOutlet weak var DrugNameLabel: UILabel!
    
    weak var delegate: CheckBoxDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        // delegate.OnCheck()
    }
}
