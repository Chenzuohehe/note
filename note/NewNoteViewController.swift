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
        
        let identifys = ["titleCell", "cell", "timeCell","switchCell"];
        
        switch indexPath {
        case indexName(.titleIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[0])! as! TitleTableViewCell
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: #selector(saveTitle(_:)), for: .editingChanged)
            
            return cell
        case indexName(.contentIndex), indexName(.voiceIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[1])!
            if indexPath == indexName(.contentIndex) {
                if self.newNote.content.isEmpty {
                    cell.textLabel?.text = "内容"
                }else{
                    cell.textLabel?.text = self.newNote.content
                }
            }else{
                cell.textLabel?.text = "语音"
            }
            return cell
        case indexName(.timeIndex):
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[2])! as! TimeTableViewCell
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifys[3])! as! SwitchTableViewCell
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
            let minuteFormatter = DateFormatter()
            minuteFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            
            let dayFormatter = DateFormatter()
            dayFormatter.setLocalizedDateFormatFromTemplate("MM-dd")
            
            let startTimeString = minuteFormatter.string(from: startTime)
            let endTimeString = minuteFormatter.string(from: endTime)
            
            var selectDay = Date()
            
            if (self.calendar.selectedDate != nil) {
                selectDay = self.calendar.selectedDate!
            }else{
                selectDay = self.calendar.today!
            }
            
            let time = dayFormatter.string(from: selectDay) + "  " + startTimeString + " ~ " + endTimeString
            timeCell.detailTimeLabel.text = time
            self.newNote.time = time
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
    }
    
    func hiddenTextField() {
        let cellIndex = NSIndexPath(row: 0, section: 0) as IndexPath
        let cell = self.tableView.cellForRow(at: cellIndex) as! TitleTableViewCell
        cell.titleTextField.resignFirstResponder()
    }
    
}

