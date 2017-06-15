//
//  ToDoListViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import BasalGifglia
import CandyBar

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskViewCellDelegate {

    static func instance() -> ToDoListViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToDoListViewController") as! ToDoListViewController
    }
    
    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TaskViewCell.self, forCellReuseIdentifier: "task")
        taskManager.delegate = self
        
        let deleteAllTasksButton = UIButton(type: .system)
        deleteAllTasksButton.backgroundColor = Helper.dopeGreen
        deleteAllTasksButton.setTitleColor(UIColor.white, for: .normal)
        deleteAllTasksButton.setTitle(" Complete All ", for: .normal)
        deleteAllTasksButton.sizeToFit()
        deleteAllTasksButton.addTarget(self, action: #selector(deleteAllTasks), for: .touchUpInside)
        let deleteAllTasksButtonView = UIView(frame: CGRect(x: 0, y: tableView.frame.minY - deleteAllTasksButton.frame.height, width: tableView.frame.width, height: deleteAllTasksButton.frame.height))
        deleteAllTasksButtonView.backgroundColor = Helper.dopeRed
        view.addSubview(deleteAllTasksButtonView)
//        deleteAllTasksButton.frame = CGRect(x: deleteAllTasksButtonView.frame.size.width - deleteAllTasksButton.frame.size.width, y: deleteAllTasksButton.frame.minY, width: deleteAllTasksButton.frame.width, height: deleteAllTasksButton.frame.height)
        deleteAllTasksButtonView.addSubview(deleteAllTasksButton)
        
        deleteAllTasksButton.translatesAutoresizingMaskIntoConstraints = false
        
        let c1 = NSLayoutConstraint(item: deleteAllTasksButton, attribute: .trailing, relatedBy: .equal, toItem: deleteAllTasksButtonView, attribute: .trailing, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: deleteAllTasksButton, attribute: .centerY, relatedBy: .equal, toItem: deleteAllTasksButtonView, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraints([c1, c2,])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if (tableView.numberOfRows(inSection: 0) == 0) {
            taskManager.addDemo()
        }
    }
    
    func deleteAllTasks() {
        let alert = UIAlertController(title: "Complete All Tasks?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            let row = self.tableView.numberOfRows(inSection: 0) - 1
            guard row >= 0 else {
                return
            }
            DispatchQueue.global().async {
                var row = row
                while (row >= 0) {
                    self.tableView.isUserInteractionEnabled = false
                    DispatchQueue.main.async {
                        taskManager.removeTask(at: row)
                        self.tableView.deleteRows(at: [IndexPath(item: row, section: 0)], with: .left)
                    }
                    Thread.sleep(forTimeInterval: 0.2)
                    
                    row = row - 1
                }
                self.tableView.isUserInteractionEnabled = true
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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
        switch Reward.getActive(for: .doneTask) {
            
        case .basalGifglia:
            self.present(UIGifgliaViewController(), animated: true, completion: nil)
            
        case .candyBar:
            CandyBar(title: "Got em!",
                     subtitle: "beep boop bop good job",
                     icon: .thumbsUp,
                     position: .bottom,
                     backgroundColor: CandyBar.hexStringToUIColor("#4286f4"))
                .show(2.5)
            
        case .balloons:
            self.tableView.showBalloons()
            
        case .starSingle:
            self.tableView.showSolidStar()
            
        case .goldenFrame:
            self.tableView.showGoldenFrame()
            
        case .starBurst:
            self.tableView.showStarburst(at: gesture.location(in: tableView))
            
        case .coins:
            self.tableView.showCoins(at: gesture.location(in: tableView))
        }
        
    }
    
    
    /* ////////////////////////////
     //
     // UITableViewDelegate
     //
     */ ////////////////////////////
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = taskManager.colorForIndex(indexPath.row)
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

