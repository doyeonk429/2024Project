//
//  AlarmCell.swift
//  DrugBox
//
//  Created by 김도연 on 1/27/24.
//

import UIKit

class AlarmCell: UITableViewCell {
    @IBOutlet weak var alarmLightIcon: UIImageView!
    @IBOutlet weak var TimestampLabel: UILabel!
    @IBOutlet weak var AlarmContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
