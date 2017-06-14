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
        tableView.reloadData()
        tableView.isScrollEnabled = false
//        tableView.separatorStyle = .none
    }
}

class DrawerItemCell: UITableViewCell {
    
    var delegate: DrawerViewControllerDelegate?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    static let itemCount: Int = 1
    static var maximumWidth: CGFloat = 280
    
    func configureItem(titleText: String, rewardType: RewardType) {
        title.text = titleText
        let doneTaskPicker = DoneTaskRewardPicker()
        picker.dataSource = doneTaskPicker
        picker.delegate = doneTaskPicker
    }
    
    func configureItem(index: Int) {
        configureItem(titleText: "Done Task Reward", rewardType: .doneTask)
        
//        
//        let oldFrame = title.frame
//        title.sizeToFit()
//        DrawerItemCell.maximumWidth = max(DrawerItemCell.maximumWidth, title.frame.maxX)
//        title.frame = oldFrame
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
        let oldMaxWidth = DrawerItemCell.maximumWidth
        cell.delegate = delegate
        cell.configureItem(index: indexPath.row)
        
//        if (oldMaxWidth != DrawerItemCell.maximumWidth) {
//            var tvFrame = tableView.frame
//            tvFrame.size.width = DrawerItemCell.maximumWidth + tableView.layoutMargins.left + tableView.layoutMargins.right
//            tableView.frame = tvFrame
//        }
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
