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
    
    static func instance() -> DrawerViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
}

class DrawerItemCell: UITableViewCell {
    
    static let newTaskRewardPickerDelegate = RewardPickerDelegate(type: .newTask)
    static let doneTaskRewardPickerDelegate = RewardPickerDelegate(type: .doneTask)
    static let allDoneTaskRewardPickerDelegate = RewardPickerDelegate(type: .allDoneTask)
    
    var delegate: DrawerViewControllerDelegate?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    static let itemCount: Int = 3
    static var maximumWidth: CGFloat = 280
    
    func configureItem(index: Int) {
        switch index {
        case 0:
            title.text = "Adding Task"
            picker.dataSource = DrawerItemCell.newTaskRewardPickerDelegate
            picker.delegate = DrawerItemCell.newTaskRewardPickerDelegate
            picker.selectRow(Reward.getActiveIndex(for: .newTask), inComponent: 0, animated: false)
        case 1:
            title.text = "Finishing Task"
            picker.dataSource = DrawerItemCell.doneTaskRewardPickerDelegate
            picker.delegate = DrawerItemCell.doneTaskRewardPickerDelegate
            picker.selectRow(Reward.getActiveIndex(for: .doneTask), inComponent: 0, animated: false)
        case 2:
            title.text = "Finishing All Tasks"
            picker.dataSource = DrawerItemCell.allDoneTaskRewardPickerDelegate
            picker.delegate = DrawerItemCell.allDoneTaskRewardPickerDelegate
            picker.selectRow(Reward.getActiveIndex(for: .allDoneTask), inComponent: 0, animated: false)
        default:
            fatalError("Unconfigured Reward Selector")
        }
    }
    
}

// MARK: UITableViewDataSource
extension DrawerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DrawerItemCell.itemCount
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerItemCell", for: indexPath) as! DrawerItemCell
        
        cell.delegate = delegate
        cell.configureItem(index: indexPath.row)
        
        return cell
    }
    
    
}

// MARK: UITableViewDelegate
extension DrawerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedItem =
        tableView.deselectRow(at: indexPath, animated: true)
//        Helper.log("Selected row number \(indexPath.row)")
    }
}
