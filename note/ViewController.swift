//
//  ViewController.swift
//  note
//
//  Created by ChenZuo on 2017/7/24.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var today = DayModel()
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        //        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.scopeGesture)
        self.calendar.scope = .month
        self.calendar.locale = Locale(identifier: "zh_CN")
        self.calendar.appearance.eventDefaultColor = noteColor1
        
        reloadCollection(Date())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reload 一下 确认选中日期
        
        if (self.calendar.selectedDate != nil) {
            reloadCollection(self.calendar.selectedDate!)
        }else{
            reloadCollection(Date())
        }
        self.calendar.reloadData()
    }
    
    func reloadCollection(_ date:Date) {
        var hasNote = false
        
        for dayModel in days {
            if dayModel.day == dayString(date) {
                today = dayModel
                mainCollectionView.reloadData()
                hasNote = true
            }
        }
        if !hasNote {
            today = DayModel()
            today.setDate(date)
            mainCollectionView.reloadData()
        }
    }
    
    //MARK:- FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        reloadCollection(date)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for dayModel in days {
            if dayModel.dayDate == date {
                return (dayModel.notes?.count)!
            }
        }
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if today.notes == nil {
            return
        }
        if indexPath.row == today.notes?.count {
            return
        }
        
        let nextViewController = DisPlayTableViewController()
        let noteModel = today.notes?[indexPath.row]
        nextViewController.note = noteModel
        self.navigationController?.pushViewController(nextViewController, animated: true)
        print("123")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if today.notes == nil {
            return 1
        }
        return today.notes!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cSCREEN_WIDTH - 30)/2, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if today.notes == nil || indexPath.row == today.notes?.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addNew", for: indexPath)
            cell.layer.cornerRadius = 4
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.layer.cornerRadius = 4
        let noteModel = today.notes?[indexPath.row]
        cell.dayLabel.text = noteModel?.creatDay
        cell.titleLabel.text = noteModel?.title
        cell.contentLabel.text = noteModel?.content
//        cell.contentLabel.sizeToFit()
        return cell
    }
    
    @IBAction func reset(_ sender: Any) {
        archiverDays([])
    }
    
    @IBAction func refresh(_ sender: Any) {
        days = unArchiverDays()
        print(days)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new" {
            segue.destination.setValue(today.dayDate, forKey: "time")
        }
    }
}

