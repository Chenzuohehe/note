//
//  TextTableViewCell.swift
//  note
//
//  Created by ChenZuo on 2017/8/28.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    var note:NoteModel?
    
    var titleLable:UILabel = {
        let label = UILabel()
        
        return label
    }()
    let timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let contentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let playButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playButton"), for: .normal)
        return button
    }()
    let voiceLabel:UILabel = {
        let label = UILabel()
        
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
        
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
        }
        self.titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(8)
        }
        self.titleLable.textAlignment = .center
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(18)
            make.right.bottom.equalTo(self.contentView).offset(-18)
            make.top.equalTo(self.titleLable.snp.bottom).offset(18)
        }
        
    }
    
    func bind(_ note:NoteModel) {
        self.note = note
        self.titleLable.text = self.note?.title
        self.timeLabel.text = self.note?.creatDay
        self.contentLabel.text = self.note?.content
        self.voiceLabel.text = self.note?.voiceName
        
        if let _ = self.note, let _ = self.note?.voiceName {
            self.contentView.addSubview(self.playButton)
            self.contentView.addSubview(self.voiceLabel)
            
            self.playButton.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(8)
                make.bottom.equalTo(self.contentView).offset(-8)
                make.width.height.equalTo(40)
                
            })
            self.voiceLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.playButton.snp.right).offset(8)
                make.right.equalTo(self.contentView).offset(-8)
                make.bottom.equalTo(self.contentView).offset(-8)
            })
            
            self.contentLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(8)
                make.right.equalTo(self.contentView).offset(-8)
                make.top.equalTo(self.timeLabel.snp.bottom).offset(8)
                make.bottom.equalTo(self.playButton.snp.top).offset(-8)
                make.bottom.equalTo(self.voiceLabel.snp.top).offset(-8)
            })
        }
        
    }
}
