//
//  note+Define.swift
//  note
//
//  Created by ChenZuo on 2017/8/3.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

func noteColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 0.1)
}


func getLocalDate(_ date:Date) -> Date {
    
    let localTimeZone = NSTimeZone.local
    let localGMTOfset = localTimeZone.secondsFromGMT(for: date)
    
    let dateNow = NSDate(timeInterval: TimeInterval(localGMTOfset), since: date)
    return dateNow as Date
}

func makePost(_ string:String, _ superView:UIView) {
    
    let hub = MBProgressHUD.showAdded(to: superView, animated: true)
    hub.removeFromSuperViewOnHide = true
    hub.label.text = string
    hub.mode = .text
    hub.label.font = UIFont.systemFont(ofSize: 14)
    hub.show(animated: true)
    hub.hide(animated: true, afterDelay: 1)
    
}


