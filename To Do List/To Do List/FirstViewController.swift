//
//  FirstViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import BasalGifglia
import CandyBar

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskViewCellDelegate {

    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TaskViewCell.self, forCellReuseIdentifier: "task")
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        if (tableView.numberOfRows(inSection: 0) == 0) {
            taskManager.addDemo()
        }
    }
    
    
    
    /* ////////////////////////////
     //
     // TaskViewCellDelegate
     //
     */ ////////////////////////////
    
    func taskItemDeleted(_ taskItem: Task) {
        if let index = taskManager.tasks.index(of: taskItem){
            taskManager.removeTask(at: index)
            
            tableView.beginUpdates()
            let indexPathForRow = IndexPath(item: index, section: 0)
            tableView.deleteRows(at: [indexPathForRow], with: .left)
            tableView.endUpdates()
            if (taskManager.tasks.count == 0) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    taskManager.addDemo()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func presentReward(view: UIView, gesture: UIGestureRecognizer) {
        switch RewardType.get() {
            
        case .basalGifglia:
            self.present(UIGifgliaViewController(), animated: true, completion: nil)
            
        case .candyBar:
            CandyBar(title: "Got em!",
                     subtitle: "beep boop bop good job",
                     icon: .thumbsUp,
                     position: .bottom,
                     backgroundColor: CandyBar.hexStringToUIColor("#4286f4"))
                .show(2.5)
        case .starBurst:
            self.tableView.showStarburst(at: gesture.location(in: tableView))
            
        case .balloons:
            self.tableView.showBalloons()
            
        case .coins:
            self.tableView.showCoins(at: gesture.location(in: tableView))
            
        case .starSingle:
            self.tableView.showSolidStar()
        }
        
    }
    
    
    /* ////////////////////////////
     //
     // UITableViewDelegate
     //
     */ ////////////////////////////
    
    func colorForIndex(_ index: Int) -> UIColor{
        let itemCount = taskManager.tasks.count - 1
        let val = (CGFloat (index) / CGFloat(itemCount)) * (204/255.0)
        return UIColor.init(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    
     /* ////////////////////////////
     //
     // UITableViewDataSource
     //
     */ ////////////////////////////
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return taskManager.tasks.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = TaskViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "task")
        cell.task = taskManager.tasks[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        
        cell.textLabel?.text = cell.task?.name
        cell.detailTextLabel?.text = cell.task?.additionalText
        
        return cell
    }

}

