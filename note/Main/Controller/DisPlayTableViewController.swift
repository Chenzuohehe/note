//
//  DisPlayTableViewController.swift
//  note
//
//  Created by ChenZuo on 2017/8/25.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class DisPlayTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.register(UINib.init(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextTableViewCell
        
        cell.titleLable.text = "123"
        cell.timeLabel.text = "20187777"
        cell.contentLabel.text = "cell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.textcell.detailTextLabel?.text"
        
        return cell
    }
    
}
