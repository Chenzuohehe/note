//
//  NewNoteViewController.swift
//  note
//
//  Created by ChenZuo on 2017/7/31.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {

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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hiddenTextField()
        return true
    }
    
//MARK:- action
    
    @IBAction func touchView(_ sender: UITapGestureRecognizer) {
        self.hiddenTextField()
    }
    
    func hiddenTextField() {
        let cellIndex = NSIndexPath(row: 0, section: 0) as IndexPath
        let cell = self.tableView.cellForRow(at: cellIndex) as! TitleTableViewCell
        cell.titleTextField.resignFirstResponder()
    }
    
}

