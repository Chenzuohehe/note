//
//  SwitchTableViewCell.swift
//  note
//
//  Created by ChenZuo on 2017/8/1.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var switchTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
