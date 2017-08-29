//
//  TextTableViewCell.swift
//  note
//
//  Created by ChenZuo on 2017/8/28.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
//    @IBOutlet weak var titleLabel: UILabel!
//
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var contextLabel: UILabel!
    
    var titleLable:UILabel = {
        let label = UILabel()
        
        return label
    }()
    let timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    let contentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.contentView.addSubview(self.titleLable)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.contentLabel)
        
        self.titleLable.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
//            make.top.equalTo(self.contentView).offset(8)
        }
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
            make.top.equalTo(self.titleLable.snp.bottom).offset(8)
        }
//
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(8)
            make.right.bottom.equalTo(self.contentView).offset(-8)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(8)
        }
    }
}
