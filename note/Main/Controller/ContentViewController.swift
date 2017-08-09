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
        
        let backView = UIView(frame: CGRect(x: 0, y: 208 + 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 208))
        backView.backgroundColor = noteColor(red: 123, green: 123, blue: 123)
        self.view.addSubview(backView)
        
        self.view.addSubview(self.textView)
        self.textView.snp.makeConstraints { (make) in
            make.top.equalTo(8 + 64)
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(200)
        }
        self.textView.text = "123"
        self.textView.font = UIFont.systemFont(ofSize: 15)
        
        let rightBtn = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(confrimClick))
        self.navigationItem.rightBarButtonItem = rightBtn
    }

    override func viewWillAppear(_ animated: Bool) {
        self.textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    typealias changUserName = (String) ->()
    var changText: changUserName?
    
    
    func confrimClick() {
        if let handel = self.changText {
            handel(self.textView.text)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
