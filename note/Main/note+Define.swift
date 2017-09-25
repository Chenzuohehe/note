//
//  note+Define.swift
//  note
//
//  Created by ChenZuo on 2017/8/3.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

let cSCREEN_WIDTH = UIScreen.main.bounds.size.width
let cSCREEN_HEIGHT = UIScreen.main.bounds.size.height

let cIS_iPhoneX = (UIScreen.main.bounds.size.height == 812)
let cNAVIGATION_HEIGHT:CGFloat = cIS_iPhoneX ? 88:64



func noteColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
}

let noteColor1 = UIColor(red: 196/255.0, green: 225/255.0, blue: 137/255.0, alpha: 1)
let noteColor2 = UIColor(red: 123/255.0, green: 201/255.0, blue: 111/255.0, alpha: 1)
let noteColor3 = UIColor(red: 35/255.0, green: 154/255.0, blue: 59/255.0, alpha: 1)
let noteColor4 = UIColor(red: 25/255.0, green: 97/255.0, blue: 39/255.0, alpha: 1)

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

func dayString(_ date:Date) -> String {
    let dayFormatter = DateFormatter()
    dayFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
    let dayString = dayFormatter.string(from: date)
    return dayString
}

func timeString(_ startTime: Date, _ endTime: Date,_ selecDate:Date) -> String {
    let minuteFormatter = DateFormatter()
    minuteFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
    
    let startTimeString = minuteFormatter.string(from: startTime)
    let endTimeString = minuteFormatter.string(from: endTime)
    let time = dayString(selecDate) + "  " + startTimeString + " ~ " + endTimeString
    
    return time
}
