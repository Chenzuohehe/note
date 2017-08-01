//
//  TitleTableViewCell.swift
//  note
//
//  Created by ChenZuo on 2017/8/1.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
