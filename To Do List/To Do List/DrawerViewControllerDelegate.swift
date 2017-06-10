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
        tableView.separatorStyle = .none
        
        let screenRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: UIScreen.main.bounds.size)
        let imageViewBackground = UIImageView(frame: screenRect)
        let overlay = UIView.init(frame: screenRect)
        overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        imageViewBackground.image = UIImage(named: "purple-nebula")
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        imageViewBackground.addSubview(overlay)
        view.addSubview(imageViewBackground)
        view.sendSubview(toBack: imageViewBackground)
    }
}

class DrawerItemCell: UITableViewCell {
    
    var delegate: DrawerViewControllerDelegate?
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    static let itemCount: Int = 6
    static var maximumWidth: CGFloat = 160
    
    func configureItem(titleText: String, iconImage: UIImage) {
        title.text = titleText
        icon.image = iconImage
    }
    
    func configureItem(index: Int) {
        
//        var singleTap: UITapGestureRecognizer?
//        
//        switch index {
//        case 0:
//            self.configureItem(titleText: "Home", iconImage: UIImage(named: "icon-home")!)
//            singleTap = UITapGestureRecognizer(target: delegate, action: #selector(DrawerViewControllerDelegate.presentChickletListViewController))
//            
//        case 1:
//            self.configureItem(titleText: "Breathe Now", iconImage: UIImage(named: "icon-breathe")!)
//            singleTap = UITapGestureRecognizer(target: delegate, action: #selector(DrawerViewControllerDelegate.presentBreatheNowViewController))
//        
//        case 2:
//            self.configureItem(titleText: "Tutorial", iconImage: UIImage(named: "icon-tutorial")!)
//            singleTap = UITapGestureRecognizer(target: delegate, action: #selector(DrawerViewControllerDelegate.presentTutorialViewController))
//        
//        case 3:
//            self.configureItem(titleText: "Send Feedback", iconImage: UIImage(named: "icon-feedback")!)
//            singleTap = UITapGestureRecognizer(target: delegate, action: #selector(DrawerViewControllerDelegate.presentFeedbackEmail))
//            
//        case 4:
//            self.configureItem(titleText: "About Us", iconImage: UIImage(named: "icon-about-us")!)
//            icon.tintColor = UIColor.white
//            singleTap = UITapGestureRecognizer(target: delegate, action: #selector(DrawerViewControllerDelegate.presentAboutViewController))
//            
//        case 5:
//            self.configureItem(titleText: "Share Space", iconImage: UIImage(named: "icon-share")!)
//            singleTap = UITapGestureRecognizer(target: delegate, action: #selector(DrawerViewControllerDelegate.presentShareActivity))
//            
//        default:
//            break
//        }
//        
//        if let singleTap = singleTap {
//            singleTap.numberOfTapsRequired = 1
//            self.isUserInteractionEnabled = true
//            self.addGestureRecognizer(singleTap)
//        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let image = UIImage(named: "brain-with-space") {
//            let imageView = UIImageView(image: image)
//            imageView.contentMode = .scaleAspectFit
//            return imageView
//        } else {
            return UIView()
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerItemCell", for: indexPath) as! DrawerItemCell
        let oldMaxWidth = DrawerItemCell.maximumWidth
        cell.delegate = delegate
        cell.configureItem(index: indexPath.row)
        
        if (oldMaxWidth != DrawerItemCell.maximumWidth) {
            var tvFrame = tableView.frame
            tvFrame.size.width = DrawerItemCell.maximumWidth + tableView.layoutMargins.left + tableView.layoutMargins.right
            tableView.frame = tvFrame
        }
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
