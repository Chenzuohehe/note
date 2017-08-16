//
//  NoteModel.swift
//  note
//
//  Created by ChenZuo on 2017/8/8.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class NoteModel: NSObject , NSCoding{
    var title = String()
    var content = String()
    var time = String()
    
    var addToCalender = Bool()
    var addAddress = Bool()
    
    //语音
    var voiceName = String()
    var voiceURLString = String()
    
    //地理坐标
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(time, forKey: "time")
        
        aCoder.encode(addToCalender, forKey: "addToCalender")
        aCoder.encode(addAddress, forKey: "addAddress")
        
        aCoder.encode(voiceName, forKey: "voiceName")
        aCoder.encode(voiceURLString, forKey: "voiceURLString")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        title = aDecoder.decodeObject(forKey: "title") as! String
        content = aDecoder.decodeObject(forKey: "content") as! String
        time = aDecoder.decodeObject(forKey: "time") as! String
        
        
        
        voiceName = aDecoder.decodeObject(forKey: "voiceName") as! String
        voiceURLString = aDecoder.decodeObject(forKey: "voiceURLString") as! String
    }
    
    override init(){
        
    }
}


class DayModel: NSObject, NSCoding {
    var creatTime = String()
    var notes = [NoteModel]()
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(creatTime, forKey: "creatTime")
        aCoder.encode(notes, forKey: "notes")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        creatTime = aDecoder.decodeObject(forKey: "creatTime") as! String
        notes = aDecoder.decodeObject(forKey: "notes") as! [NoteModel]
    }
    
    override init() {
        
    }
}
