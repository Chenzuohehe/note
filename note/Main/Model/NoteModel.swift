//
//  NoteModel.swift
//  note
//
//  Created by ChenZuo on 2017/8/8.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class NoteModel: NSObject , NSCoding{
    var title:String?
    var content:String?
    
    var creatDay:String?
    var startDate:Date?
    var endDate:Date?
    
    
    var addToCalender:Bool?
    var addAddress:Bool?
    
    //语音
    var voiceName:String?
    var voiceURLString:String?
    
    //地理坐标
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(content, forKey: "content")
//        aCoder.encode(time, forKey: "time")
        
        aCoder.encode(addToCalender, forKey: "addToCalender")
        aCoder.encode(addAddress, forKey: "addAddress")
        
        aCoder.encode(voiceName, forKey: "voiceName")
        aCoder.encode(voiceURLString, forKey: "voiceURLString")
    }
    
    required init?(coder aDecoder: NSCoder) {
//        super.init()
        
        title = aDecoder.decodeObject(forKey: "title") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
//        time = aDecoder.decodeObject(forKey: "time") as! String
        
        
        
        voiceName = aDecoder.decodeObject(forKey: "voiceName") as? String
        voiceURLString = aDecoder.decodeObject(forKey: "voiceURLString") as? String
    }
    
    override init(){
        
    }
}

class DayModel: NSObject, NSCoding {
    var day:String?
    var notes:[NoteModel]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.day, forKey: "day")
        aCoder.encode(self.notes, forKey: "notes")
    }
    
    required init?(coder aDecoder: NSCoder) {
//        super.init()
        
        self.day = aDecoder.decodeObject(forKey: "day") as? String
        self.notes = aDecoder.decodeObject(forKey: "notes") as? [NoteModel]
    }
    
    override init() {
        
    }
    //添加对note的排序
    func noteSort() {
        
    }
    
}


let ContactFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/days.data"
var days = [DayModel]()

//增删改差，放在哪进行呢

func archiverDays(_ days:[DayModel]) {
    NSKeyedArchiver.archiveRootObject(days, toFile: ContactFilePath)
}

func unArchiverDays() -> [DayModel] {
    if let days = NSKeyedUnarchiver.unarchiveObject(withFile: ContactFilePath) {
        return days as! [DayModel]
    }else{
        return []
    }
}


