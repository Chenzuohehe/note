//
//  NewNoteViewController.swift
//  note
//
//  Created by ChenZuo on 2017/7/31.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit
import SnapKit

class NewNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, timePickerDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHight: NSLayoutConstraint!
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    let touch = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.tableView.tableFooterView = UIView()
        self.calendar.scope = .week
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewNoteViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        self.calendar.setScope(.week, animated: true)
    }
    

//MARK:- UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
//MARK:- FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHight.constant = bounds.height
        self.view.layoutIfNeeded()
        if self.calendar.scope == .month {
            self.hiddenTextField()
        }
        
    }
    
//MARK:- tableViewDelegate/dataSoure
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifys = ["titleCell", "cell", "timeCell","switchCell"];
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[0])! as! TitleTableViewCell
            cell.titleTextField.delegate = self
            return cell
        case 1, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[1])!
            if indexPath.row == 1 {
                cell.textLabel?.text = "内容"
            }else{
                cell.textLabel?.text = "语音"
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[2])! as! TimeTableViewCell
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[3])! as! SwitchTableViewCell
            if indexPath.row == 3 {
                cell.switchTitleLabel.text = "是否添加到系统日历"
            }else{
                cell.switchTitleLabel.text = "是否添加地理标注"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hiddenTextField()
        self.showTimePicker()
    }
    
    let timePicker = Bundle.main.loadNibNamed("TimePickerView", owner: nil, options: nil)?.last as! TimePickerView
    
    func showTimePicker() {

        self.view.addSubview(self.timePicker)
        let toucTap = UITapGestureRecognizer(target: self, action: #selector(hiddenTimePicker))
        self.timePicker.addGestureRecognizer(toucTap)
        
        self.timePicker.delegate = self
        
        self.timePicker.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.6) {
            self.timePicker.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            self.view.layoutIfNeeded()
        }
    }
    
    func getPickTime(_ startTime: Date, _ endTime: Date) {
        
        getLocalDate(startTime)
        print("开始", startTime,"结束" , endTime)
        
        
    }
    
    func hiddenTimePicker() {
        UIView.animate(withDuration: 0.6, animations: {
            self.timePicker.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 300)
        }) { (success) in
            self.timePicker.removeFromSuperview()
        }
    }
    
//MARK:- UIPickerViewDelegate/datasoure
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH / 8
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "123"
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.hiddenTimePicker()
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 8 - 5, height: 50))
        titleLabel.backgroundColor = UIColor.red
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = noteColor(red: 86, green: 86, blue: 86)
        return titleLabel
    }
    
//MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hiddenTextField()
        return true
    }
    
//MARK:- action
    
    func hiddenTextField() {
        let cellIndex = NSIndexPath(row: 0, section: 0) as IndexPath
        let cell = self.tableView.cellForRow(at: cellIndex) as! TitleTableViewCell
        cell.titleTextField.resignFirstResponder()
        
//        self.timePickerView.removeFromSuperview()
    }
    
}

