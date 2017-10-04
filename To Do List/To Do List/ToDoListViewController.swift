//
//  ToDoListViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import BasalGifglia
import DopamineKit
import CandyBar

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskViewCellDelegate {

    static func instance() -> ToDoListViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToDoListViewController") as! ToDoListViewController
    }
    
    
    var container: ContainerViewController? = nil
    
    @IBOutlet weak var brainLogo: UIImageView!
    @IBOutlet var tableView:UITableView!
    var deleteAllTasksButton: UIButton? = nil
    var deleteAllTasksView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brainLogo.addGestureRecognizer(UITapGestureRecognizer.init(target: brainLogo, action: #selector(brainLogo.showGlow)))
        
        tableView.register(TaskViewCell.self, forCellReuseIdentifier: "task")
        taskManager.delegate = self
        
        if deleteAllTasksButton == nil {
            let deleteAllTasksButton = UIButton(type: .system)
            deleteAllTasksButton.backgroundColor = Helper.dopeGreen
            deleteAllTasksButton.setTitleColor(UIColor.white, for: .normal)
            deleteAllTasksButton.setTitle(" Complete All ", for: .normal)
            deleteAllTasksButton.sizeToFit()
            deleteAllTasksButton.addTarget(self, action: #selector(deleteAllTasks), for: .touchUpInside)
            let deleteAllTasksView = UIView(frame: CGRect(x: 0, y: tableView.frame.minY - deleteAllTasksButton.frame.height, width: tableView.frame.width, height: deleteAllTasksButton.frame.height))
            deleteAllTasksView.backgroundColor = Helper.dopeRed
            view.addSubview(deleteAllTasksView)
            //        deleteAllTasksButton.frame = CGRect(x: deleteAllTasksButtonView.frame.size.width - deleteAllTasksButton.frame.size.width, y: deleteAllTasksButton.frame.minY, width: deleteAllTasksButton.frame.width, height: deleteAllTasksButton.frame.height)
            deleteAllTasksView.addSubview(deleteAllTasksButton)
            
            deleteAllTasksButton.translatesAutoresizingMaskIntoConstraints = false
            
            let c1 = NSLayoutConstraint(item: deleteAllTasksButton, attribute: .trailing, relatedBy: .equal, toItem: deleteAllTasksView, attribute: .trailing, multiplier: 1, constant: 0)
            let c2 = NSLayoutConstraint(item: deleteAllTasksButton, attribute: .centerY, relatedBy: .equal, toItem: deleteAllTasksView, attribute: .centerY, multiplier: 1, constant: 0)
            view.addConstraints([c1, c2,])
            self.deleteAllTasksButton = deleteAllTasksButton
            self.deleteAllTasksView = deleteAllTasksView
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if (tableView.numberOfRows(inSection: 0) == 0) {
            taskManager.addDemo()
        }
        
//        self.showTutorial()
    }
    
    func showTutorial() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presentTutorialAlert(title: "Demo App", message: "DopamineLabs© 2017\n\nThis demonstration app uses positive reinforcement to build a productive task-completing habit!\n\nThere are 3 actions reinforced with DopamineKit.\n\nLet's take a look around...", skipButton: true) {
                
                // Show complete-task-action
                (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TaskViewCell).showTutorial(tableViewController: self, completion: {
                    
                    // Show complete-all-task-action
                    self.showCompeleteAllTutorial( completion: {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // Show add-task-action
                            self.container!.addLeftPanelViewController()
                            self.container!.leftViewController!.showTutorial(tableViewController: self, completion: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    // Show reward-selection
                                    self.container!.addRightPanelViewController()
                                    self.container!.rightViewController?.showTutorial(tableViewController: self, completion: {
                                        
                                        self.presentTutorialAlert(title: "Demo App", message: "Enjoy!\n\nusedopamine.com", nextButtonText: "Finish")
                                    })
                                }
                            })
                        }
                    })
                    
                })
            }
        }
    }
    
    func showCompeleteAllTutorial(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            // Setup
            let frame = self.deleteAllTasksView?.frame
            frame?.offsetBy(dx: (self.deleteAllTasksView?.frame.width)! - (self.deleteAllTasksButton?.frame.width)!, dy: 0)
            let overlay = TAOverlayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                                      height: UIScreen.main.bounds.height), subtractedPaths: [
                                                        TARectangularSubtractionPath(frame: frame!)
                ])
            overlay.alpha = 0
            self.view.addSubview(overlay)
            // Animate
            UIView.animate(withDuration: 0.5, animations: {overlay.alpha = TAOverlayView.defaultAlpha}, completion: { success in
                // Message
                self.presentTutorialAlert(title: "Reinforced Action (2/3)", message: "Press to complete all tasks!\n\nReceiving rewards is determined by layers of machine learning.") {
                    // Breakdown
                    UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveLinear, animations: {overlay.alpha = 0}, completion: { _ in
                        overlay.removeFromSuperview()
                        completion()
                    })
                }
                
            })
        }
    }
    
    func deleteAllTasks() {
        guard tableView.numberOfRows(inSection: 0) > 0 else {
            let alert = UIAlertController(title: "Add Tasks", message: "First add some tasks", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        let alert = UIAlertController(title: "Complete All Tasks?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            let row = self.tableView.numberOfRows(inSection: 0) - 1
            guard row >= 0 else {
                return
            }
            DispatchQueue.global().async {
                self.reinforceTaskAllDoneAction()
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
    
    func taskItemDeleted(_ taskItem: Task, animation: UITableViewRowAnimation = .left) {
        if let index = taskManager.tasks.index(of: taskItem){
            taskManager.removeTask(at: index)
            
            tableView.beginUpdates()
            let indexPathForRow = IndexPath(item: index, section: 0)
            tableView.deleteRows(at: [indexPathForRow], with: animation)
            tableView.endUpdates()
            if (taskManager.tasks.count == 0) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    taskManager.addDemo()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func presentTaskDoneReward(view: UIView, gesture: UIGestureRecognizer) {
        switch Reward.getActive(for: .doneTask) {
            
        case .basalGifglia:
            self.present(UIGifgliaViewController(), animated: true, completion: nil)
            
        case .candyBar:
            CandyBar(title: "Got em!",
                     subtitle: "beep boop bop good job",
                     icon: CandyIcon.randomIcon(),
                     position: arc4random() % 2 == 0 ? .top : .bottom,
                     backgroundColor: CandyBar.hexStringToUIColor("#4286f4"))
                .show(2.5)
            
        case .balloons:
            self.tableView.showBalloons()
            
        case .starSingle:
            self.tableView.showSolidStar()
            
        case .starBurst:
            self.tableView.showStarburst(at: gesture.location(in: tableView))
            
        case .coins:
            self.tableView.showCoins(at: gesture.location(in: tableView))
            
        case .confetti:
            self.tableView.showConfetti()
            
        default:
            break
        }
        
    }
    
    func reinforceTaskAllDoneAction() {
        DopamineKit.reinforce("action1", completion: {reinforcement in
            DispatchQueue.main.async(execute: {
                // NOTE: rearranged cases to have rewards show more often for demonstration
                switch(reinforcement){
                case "thumbsUp" :
                    return
                default:
                    switch (Reward.getActive(for: .allDoneTask)) {
                    case .goldenFrame:
                        self.tableView.showGoldenFrame()
                    case .balloons:
                        self.tableView.showBalloons()
                    default:
                        return
                    }
                }
            })
        })
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

