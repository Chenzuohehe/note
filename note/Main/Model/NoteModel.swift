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
    
    var creatDate:Date?
    var startDate:Date?
    var endDate:Date?
    
    var addToCalender:Bool?
    var addAddress:Bool?
    
    //语音
    var voiceName:String?
    var voiceURL:URL?
    
    //地理坐标
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(creatDay, forKey: "creatDay")
        
        aCoder.encode(creatDate, forKey: "creatDate")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
        
        aCoder.encode(addToCalender, forKey: "addToCalender")
        aCoder.encode(addAddress, forKey: "addAddress")
        
        aCoder.encode(voiceName, forKey: "voiceName")
        aCoder.encode(voiceURL, forKey: "voiceURL")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        title = aDecoder.decodeObject(forKey: "title") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        creatDay = aDecoder.decodeObject(forKey: "creatDay") as? String
        
        creatDate = aDecoder.decodeObject(forKey: "creatDay") as? Date
        startDate = aDecoder.decodeObject(forKey: "startDate") as? Date
        endDate = aDecoder.decodeObject(forKey: "endDate") as? Date
        
        addToCalender = aDecoder.decodeObject(forKey: "addToCalender") as? Bool
        addAddress = aDecoder.decodeObject(forKey: "addAddress") as? Bool
        
        voiceName = aDecoder.decodeObject(forKey: "voiceName") as? String
        voiceURL = aDecoder.decodeObject(forKey: "voiceURL") as? URL
    }
    
    override init(){
        self.creatDate = Date()
        self.creatDay = dayString(Date())
    }
}

class DayModel: NSObject, NSCoding {
    var day:String?
    var dayDate:Date?
    
    var notes:[NoteModel]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.day, forKey: "day")
        aCoder.encode(self.dayDate, forKey: "dayDate")
        aCoder.encode(self.notes, forKey: "notes")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.day = aDecoder.decodeObject(forKey: "day") as? String
        self.dayDate = aDecoder.decodeObject(forKey: "dayDate") as? Date
        self.notes = aDecoder.decodeObject(forKey: "notes") as? [NoteModel]
    }
    
    override init() {
        
    }
    
    func setDate(_ date:Date) {
        let dayFormatter = DateFormatter()
        dayFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
        self.day = dayFormatter.string(from: date)
        dayFormatter.setLocalizedDateFormatFromTemplate("yyyy/MM/dd")
        let dayString = dayFormatter.string(from: date)
        self.dayDate = dayFormatter.date(from: dayString)
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


