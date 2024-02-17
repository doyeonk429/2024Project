//
//  BoxCell.swift
//  DrugBox
//
//  Created by 김도연 on 2/3/24.
//

import UIKit

class BoxCell: UITableViewCell {
    @IBOutlet weak var boxImage: UIImageView!
    @IBOutlet weak var BoxNameLabel: UILabel!
    @IBOutlet weak var SettingButton: UIButton!
    var drugboxId : Int = 0
    
    weak var delegate: ButtonTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10, bottom: 10, right: 10))
    }
    
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        delegate?.cellButtonTapped(sender.tag)
    }
    
}
