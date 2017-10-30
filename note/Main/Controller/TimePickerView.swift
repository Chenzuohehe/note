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
    @IBOutlet weak var alphaBackView: UIView!
    
    var timeString = String()
    var startTimeString:String?
    var endTimeString:String?
    
    var startHour:String?
    var startMinute:String?
    var endHour:String?
    var endMinute:String?
    
    let minuteFormatter = DateFormatter()
    
    weak var delegate:timePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.startDatePicker.delegate = self
        self.startDatePicker.dataSource = self
        self.endDatePicker.delegate = self
        self.endDatePicker.dataSource = self
        
        minuteFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        if self.startTimeString == nil {
            self.startTimeString = minuteFormatter.string(from: Date())
            print(self.startTimeString!)
        }
        if self.endTimeString == nil {
            self.endTimeString = minuteFormatter.string(from: Date())
            
            print(self.endTimeString!)
        }
        
        startHour = self.startTimeString?.substring(to: self.startTimeString!.range(of: ":")!.lowerBound)
        startMinute = self.startTimeString?.substring(from: self.startTimeString!.range(of: ":")!.upperBound)
        endHour = self.endTimeString?.substring(to: self.endTimeString!.range(of: ":")!.lowerBound)
        endMinute = self.endTimeString?.substring(from: self.endTimeString!.range(of: ":")!.upperBound)
        
        self.startDatePicker.selectRow(Int(startHour!)!, inComponent: 0, animated: true)
        self.startDatePicker.selectRow(Int(startMinute!)!, inComponent: 2, animated: true)
        self.endDatePicker.selectRow(Int(endHour!)!, inComponent: 0, animated: true)
        self.endDatePicker.selectRow(Int(endMinute!)!, inComponent: 2, animated: true)
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
        if component == 1 {
            return
        }
        
        if pickerView == self.startDatePicker {
            if component == 0 {
                startHour = String(row)
            }else if component == 2{
                startMinute = String(row)
            }
        }else{
            if component == 0 {
                endHour = String(row)
            }else if component == 2{
                endMinute = String(row)
            }
        }
        
        let startTimeString = String(format: "%@:%@", startHour!,startMinute!)
        let endTimeString = String(format: "%@:%@", endHour!,endMinute!)
        
        let startDate = minuteFormatter.date(from: startTimeString)
        let endDate = minuteFormatter.date(from: endTimeString)
        
        print(startTimeString, startDate!, endTimeString, endDate!)
        self.delegate?.getPickTime(startDate!, endDate!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return ":"
        }
        return String(row)
    }
    
    
}
