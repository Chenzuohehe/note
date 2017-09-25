//
//  ContentViewController.swift
//  note
//
//  Created by ChenZuo on 2017/8/7.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加内容"
        self.view.backgroundColor = noteColor(red: 240, green: 240, blue: 240)
//        self.view.backgroundColor = UIColor.white
//        let backView = UIView(frame: CGRect(x: 0.0, y: cNAVIGATION_HEIGHT, width: Double(cSCREEN_WIDTH), height: 208.0))
        let backView = UIView(frame: CGRect(x: 0, y: cNAVIGATION_HEIGHT, width: cSCREEN_WIDTH, height: 208))
        
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        
        self.view.addSubview(self.textView)
        self.textView.snp.makeConstraints { (make) in
            make.top.equalTo(8 + cNAVIGATION_HEIGHT)
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(200)
        }
//        self.textView.text = "123"
        self.textView.font = UIFont.systemFont(ofSize: 15)
        
        let rightBtn = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(confrimClick))
        self.navigationItem.rightBarButtonItem = rightBtn
    }

    override func viewWillAppear(_ animated: Bool) {
        self.textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    typealias changContent = (String) ->()
    var changText: changContent?
    
    
    func confrimClick() {
        if let handel = self.changText {
            handel(self.textView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
