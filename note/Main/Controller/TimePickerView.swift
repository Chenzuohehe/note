//
//  TimePickerView.swift
//  note
//
//  Created by ChenZuo on 2017/8/4.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

@objc protocol timePickerDelegate {
    func getPickTime(_ startTime:Date, _ endTime:Date)
}

class TimePickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var startDatePicker: UIPickerView!
    @IBOutlet weak var endDatePicker: UIPickerView!
    
    var timeString = String()
    
    var startHour:String?
    var startMinute:String?
    var endHour:String?
    var endMinute:String?
    
//    var startTime:Date?
//    var endTime:Date?
    
    weak var delegate:timePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.startDatePicker.delegate = self
        self.startDatePicker.dataSource = self
        self.endDatePicker.delegate = self
        self.endDatePicker.dataSource = self
        
//        self.timeString = "00:00 - 00:00"
        if self.startHour == nil {
            self.startHour = "00"
        }
        if self.startMinute == nil {
            self.startMinute = "00"
        }
        if self.endHour == nil {
            self.endHour = "00"
        }
        if self.endMinute == nil {
            self.endMinute = "00"
        }
        
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
//        self.delegate?.getPickTime(self.startDatePicker.date, self.endDatePicker.date)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 1
        default:
            return 60
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.startDatePicker {
            if component == 0 {
                self.startHour = String(row)
            }else if component == 2{
                self.startMinute = String(row)
            }
        }else{
            if component == 0 {
                self.endHour = String(row)
            }else if component == 2{
                self.endMinute = String(row)
            }
        }
        
        let startTimeString = String(format: "%@:%@", self.startHour!,self.startMinute!)
        let endTimeString = String(format: "%@:%@", self.endHour!,self.endMinute!)
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        
        let startDate = minuteFormatter.date(from: startTimeString)
        let endDate = minuteFormatter.date(from: endTimeString)
        
        print(startTimeString, startDate!, endTimeString, endDate!)
//        minuteFormatter.date(from: )
//        self.delegate?.getPickTime(startDate!, endDate!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return ":"
        }
        return String(row)
    }
    
    
}
