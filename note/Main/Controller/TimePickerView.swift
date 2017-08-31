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

class TimePickerView: UIView {
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    weak var delegate:timePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        self.delegate?.getPickTime(self.startDatePicker.date, self.endDatePicker.date)
        
    }
    
}
