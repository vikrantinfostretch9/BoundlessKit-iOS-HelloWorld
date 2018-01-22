//
//  DrawerViewController.swift
//  Rehab
//
//  Created by Akash Desai on 4/13/17.
//  Copyright © 2017 UseDopamine. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol DrawerViewControllerDelegate {
//    func presentChickletListViewController()
//    func presentBreatheNowViewController()
//    func presentTutorialViewController()
//    func presentFeedbackEmail()
//    func presentAboutViewController()
//    func presentShareActivity()
}

class DrawerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var delegate: DrawerViewControllerDelegate?
    var container: ContainerViewController? = nil
    
    static func instance() -> DrawerViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
//        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: DrawerItemCell.maximumWidth, height: 100))
        label.text =
            "Opaque is meant for demonstration only.\n\n"
        label.numberOfLines = 0
        
        tableView.tableHeaderView = label
    }
}

// MARK: UITableViewDataSource
// MARK: UITableViewDelegate
extension DrawerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DrawerItemCell.itemCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Adding New Task Reward"
        case 1:
            return  "Completing Task Reward"
        case 2:
            return  "Completing All Tasks Reward"
        default:
            fatalError("Unconfigured Reward Selector")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerItemCell", for: indexPath) as! DrawerItemCell
        
        cell.delegate = delegate
        cell.configureItem(index: indexPath.section)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showTutorial(tableViewController: ToDoListViewController, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            // Setup
            self.container?.addRightPanelViewController()
            // Animate
            UIView.animate(withDuration: 2.2, delay: 1.0, options: .curveEaseOut, animations: {
                self.container?.animateRightPanel(shouldExpand: true)
            }) { success in
                // Message
                tableViewController.presentTutorialAlert(title: "Experiment with Reward Selection", message: "Because this is a demo, we’ve added a way to modify rewards inside the app.\n\nIn reality, rewards can be anything that gives a little joy to your users, here are just a few examples! Note: rewards with a 🎷 icon also have sound so unmute your phone to hear them!") {
                    // Breakdown
                    UIView.animate(withDuration: 2.2, delay: 1.5, options: .curveEaseIn, animations: {
                        self.container?.animateRightPanel(shouldExpand: false)
                    }, completion: {success in
                        completion()
                    })
                }
            }
        }
    }
}

class DrawerItemCell: UITableViewCell {
    
    static let newTaskRewardPickerDelegate = RewardPickerDelegate(type: .newTask)
    static let doneTaskRewardPickerDelegate = RewardPickerDelegate(type: .doneTask)
    static let allDoneTaskRewardPickerDelegate = RewardPickerDelegate(type: .allDoneTask)
    
    var delegate: DrawerViewControllerDelegate?
    
    @IBOutlet weak var picker: UIPickerView!
    
    static let itemCount: Int = 3
    static var maximumWidth: CGFloat = 260
    
    func configureItem(index: Int) {
        switch index {
        case 0:
//            title.text = "Adding Task"
            picker.dataSource = DrawerItemCell.newTaskRewardPickerDelegate
            picker.delegate = DrawerItemCell.newTaskRewardPickerDelegate
            picker.selectRow(Reward.getActiveIndex(for: .newTask), inComponent: 0, animated: false)
        case 1:
//            title.text = "Finishing Task"
            picker.dataSource = DrawerItemCell.doneTaskRewardPickerDelegate
            picker.delegate = DrawerItemCell.doneTaskRewardPickerDelegate
            picker.selectRow(Reward.getActiveIndex(for: .doneTask), inComponent: 0, animated: false)
        case 2:
//            title.text = "Finishing All Tasks"
            picker.dataSource = DrawerItemCell.allDoneTaskRewardPickerDelegate
            picker.delegate = DrawerItemCell.allDoneTaskRewardPickerDelegate
            picker.selectRow(Reward.getActiveIndex(for: .allDoneTask), inComponent: 0, animated: false)
        default:
            fatalError("Unconfigured Reward Selector")
        }
    }
    
}
