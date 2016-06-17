//
//  FirstViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskViewCellDelegate {

    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TaskViewCell.self, forCellReuseIdentifier: "task")
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    /* ////////////////////////////
     //
     // TaskViewCellDelegate
     //
     */ ////////////////////////////
    
    func taskItemDeleted(taskItem: Task) {
        if let index = taskManager.tasks.indexOf(taskItem){
            taskManager.tasks.removeAtIndex(index)
            
            tableView.beginUpdates()
            let indexPathForRow = NSIndexPath(forItem: index, inSection: 0)
            tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Left)
            tableView.endUpdates()
        }
    }
    
    
    /* ////////////////////////////
     //
     // UITableViewDelegate
     //
     */ ////////////////////////////
    
    func colorForIndex(index: Int) -> UIColor{
        let itemCount = taskManager.tasks.count - 1
        let val = (CGFloat (index) / CGFloat(itemCount)) * (204/255.0)
        return UIColor.init(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
     /* ////////////////////////////
     //
     // UITableViewDataSource
     //
     */ ////////////////////////////
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return taskManager.tasks.count
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = TaskViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "task")
        cell.task = taskManager.tasks[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .None
        
        cell.textLabel?.text = cell.task?.name
        cell.detailTextLabel?.text = cell.task?.additionalText
        
        return cell
    }

}

