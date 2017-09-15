//
//  NewNoteViewController.swift
//  note
//
//  Created by ChenZuo on 2017/7/31.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit
import SnapKit

class NewNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, timePickerDelegate {

    var time:Date?
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHight: NSLayoutConstraint!
    
    var newNote = NoteModel()
    
    enum indexPathName:Int {
        case titleIndex = 0
        case contentIndex
        case timeIndex
        case calendarIndex
        case voiceIndex
        case addressIndex
    }
    
    func indexName(_ name:indexPathName) -> IndexPath {
        return IndexPath(row: name.rawValue, section: 0)
    }
    
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
        
        print(time!)
        
//        let dayFormatter = DateFormatter()
//        dayFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
//        let dayDate = dayFormatter.date(from: time)
//        print(dayDate)
        self.calendar.select(time)
        
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    
    
//MARK:- tableViewDelegate/dataSoure
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifys = ["titleCell", "cell", "timeCell","recorderCell","switchCell"];
        
        switch indexPath {
        case indexName(.titleIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[0])! as! TitleTableViewCell
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: #selector(saveTitle(_:)), for: .editingChanged)
            cell.titleTextField?.text = self.newNote.title
            return cell
        case indexName(.contentIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[1])!
            if self.newNote.content == nil {
                cell.textLabel?.text = "内容"
            }else{
                cell.textLabel?.text = self.newNote.content
            }
            return cell
        case indexName(.timeIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[2])! as! TimeTableViewCell
            return cell
        case indexName(.voiceIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[3])! as! RecorderTableViewCell
            if self.newNote.voiceName == nil {
                cell.recorderNameLabel?.text = ""
            }else{
                cell.recorderNameLabel?.text = self.newNote.voiceName
            }
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[4])! as! SwitchTableViewCell
            if indexPath == indexName(.calendarIndex) {
                cell.switchTitleLabel.text = "是否添加到系统日历"
            }else{
                cell.switchTitleLabel.text = "是否添加地理标注"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hiddenTextField()
        switch indexPath {
        case indexName(.contentIndex):
            let nextViewController = ContentViewController()
            nextViewController.changText = { [weak self] (content:String) -> () in
                if let weakself = self {
                    weakself.newNote.content = content
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            nextViewController.view.backgroundColor = UIColor.white
            nextViewController.textView.text = self.newNote.content
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case indexName(.timeIndex):
            self.showTimePicker()
        case indexName(.voiceIndex):
            print("语音")
            
            let nextViewController = VoiceViewController(nibName: "VoiceViewController", bundle: nil)
            nextViewController.voiceBack = { [weak self] (name:String, url:URL) ->() in
                if let weakself = self {
                    weakself.newNote.voiceName = name
                    weakself.newNote.voiceURL = url
                }
            }
            self.navigationController?.pushViewController(nextViewController, animated: true)
        default:
            break
        }
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
        
        if startTime > endTime {
            makePost("开始时间必须小于结束时间", self.view)
        }else{
            let timeCell = self.tableView.cellForRow(at: indexName(.timeIndex)) as! TimeTableViewCell

            var selectDay = Date()
            
            if (self.calendar.selectedDate != nil) {
                selectDay = self.calendar.selectedDate!
            }else{
                selectDay = self.calendar.today!
            }
            
            let time = timeString(startTime, endTime, selectDay)
            timeCell.detailTimeLabel.text = time
            
            self.newNote.startDate = startTime
            self.newNote.endDate = endTime
        }
    }
    
    func hiddenTimePicker() {
        UIView.animate(withDuration: 0.6, animations: {
            self.timePicker.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 300)
        }) { (success) in
            self.timePicker.removeFromSuperview()
        }
    }
    
    
//MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hiddenTextField()
        self.saveTitle(textField)
        return true
    }
    func saveTitle(_ sender:UITextField) {
        self.newNote.title = sender.text!
        print(sender.text!)
    }
    
//MARK:- action
    @IBAction func saveNewNote(_ sender: UIBarButtonItem) {
        print(self.newNote)
        //这中间需要添加判断
        
        if self.newNote.title == nil {
            makePost("请输入标题", self.view)
            return
        }
        archiveNote()
    }
    
    func hiddenTextField() {
        let cellIndex = NSIndexPath(row: 0, section: 0) as IndexPath
        let cell = self.tableView.cellForRow(at: cellIndex) as! TitleTableViewCell
        cell.titleTextField.resignFirstResponder()
    }
    
    //判断days 里面是否有当前day
    
    func archiveNote() {
        var selectDay = Date()
        if (self.calendar.selectedDate != nil) {
            selectDay = self.calendar.selectedDate!
        }else{
            selectDay = self.calendar.today!
        }
        self.newNote.creatDay = dayString(selectDay)
        
        
        var hasDayModel = false
        let today = DayModel()
        
        for day in days {
            print(day.day!, dayString(Date()))
            if day.day! == dayString(Date()){
                hasDayModel = true
                day.notes!.append(self.newNote)
            }
        }
        
        if !hasDayModel {
            today.day = dayString(selectDay)
            today.notes = [self.newNote]
            days.append(today)
        }
        archiverDays(days)
        self.navigationController?.popViewController(animated: true)
    }
}

