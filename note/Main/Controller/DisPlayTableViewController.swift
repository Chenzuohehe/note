//
//  DisPlayTableViewController.swift
//  note
//
//  Created by ChenZuo on 2017/8/25.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit

class DisPlayTableViewController: UITableViewController {
    
    var note:NoteModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let rightBtn = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editClick))
        self.navigationItem.rightBarButtonItem = rightBtn
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextTableViewCell
        cell.bind(self.note)
        
        return cell
    }
    
    
    func editClick() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryBoard.instantiateViewController(withIdentifier: "newNote") as! NewNoteViewController
        
        nextViewController.time = self.note.creatDate
        nextViewController.newNote = self.note
        nextViewController.style = 1
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
