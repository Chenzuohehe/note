//
//  RecorderTableViewCell.swift
//  note
//
//  Created by ChenZuo on 2017/8/15.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class RecorderTableViewCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recorderNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
