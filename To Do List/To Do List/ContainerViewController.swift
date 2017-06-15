//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore
import MessageUI
import DopamineKit
import CoreBluetooth

@objc protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    func collapseSidePanels()
}

class ContainerViewController: UIViewController {
    
    enum SlideOutState {
        case Collapsed
        case LeftPanelExpanded
        case RightPanelExpanded
    }
    
    var currentState: SlideOutState = .Collapsed {
        didSet {
            let shouldShowShadow = (currentState != .Collapsed)
            showShadowForCenterViewController(shouldShowShadow: shouldShowShadow)
        }
    }
    
    var centerNavigationController: UINavigationController!
    var centerViewController: ToDoListViewController?
    var leftViewController: AddTaskViewController?
    var rightViewController: DrawerViewController?
    
    var sidePanelWidth: CGFloat {
        get {
            let margin: CGFloat = 25
            return DrawerItemCell.maximumWidth + margin
        }
    }
    
    static func instance() -> ContainerViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = ToDoListViewController.instance()
//        centerViewController?.containerDelegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController!)
        centerNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        centerNavigationController.navigationBar.shadowImage = UIImage()
        centerNavigationController.navigationBar.isTranslucent = true
        centerNavigationController.navigationBar.tintColor = UIColor.white
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
        
        let addTask = UIBarButtonItem.init(image: UIImage(named: "add-task.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openLeftController))
        centerNavigationController.topViewController?.navigationItem.leftBarButtonItem = addTask
        
        let pickReward = UIBarButtonItem.init(image: UIImage(named: "pick-reward.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openRightController))
        centerNavigationController.topViewController?.navigationItem.rightBarButtonItem = pickReward
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.cancelsTouchesInView = false
        centerNavigationController.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        animateLeftPanel(shouldExpand: currentState != .LeftPanelExpanded)
    }
    
    func toggleRightPanel() {
        animateRightPanel(shouldExpand: currentState != .RightPanelExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .LeftPanelExpanded:
            toggleLeftPanel()
        case .RightPanelExpanded:
            toggleRightPanel()
        case .Collapsed:
            break
        }
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            let drawerViewController = DrawerViewController.instance()
            drawerViewController.delegate = self
            drawerViewController.container = self
            view.insertSubview(drawerViewController.view, at: 0)
            
            addChildViewController(drawerViewController)
            drawerViewController.didMove(toParentViewController: self)
            rightViewController = drawerViewController
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            let addTaskViewController = AddTaskViewController.instance()
//            addTaskViewController.delegate = self
            addTaskViewController.container = self
            view.insertSubview(addTaskViewController.view, at: 0)
            
            addChildViewController(addTaskViewController)
            addTaskViewController.didMove(toParentViewController: self)
            leftViewController = addTaskViewController
        }
    }
    
    func removeLeftPanelViewController() {
        if (leftViewController != nil) {
            self.leftViewController?.view?.removeFromSuperview()
            self.leftViewController = nil
        }
    }
    
    func removeRightPanelViewController() {
        if (rightViewController != nil) {
            self.rightViewController?.view?.removeFromSuperview()
            self.rightViewController = nil
        }
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            addLeftPanelViewController()
            animateCenterPanelXPosition(targetPosition: sidePanelWidth)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .Collapsed
                self.removeLeftPanelViewController()
            }
        }
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            addRightPanelViewController()
            animateCenterPanelXPosition(targetPosition: 0 - sidePanelWidth)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .Collapsed
                self.removeRightPanelViewController()
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
        
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func openLeftController() {
        addLeftPanelViewController()
        animateLeftPanel(shouldExpand: currentState == .Collapsed)
    }
    
    func openRightController() {
        addRightPanelViewController()
        animateRightPanel(shouldExpand: currentState == .Collapsed)
    }
}

// MARK: DrawerViewControllerDelegate

extension ContainerViewController: DrawerViewControllerDelegate {
//    internal func presentChickletListViewController() {
//        centerNavigationController.popToRootViewController(animated: true)
//        collapseSidePanels()
//    }
//    
//    func presentBreatheNowViewController() {
//        centerNavigationController?.pushViewController(BreatheNowViewController.instance(), animated: true)
//        collapseSidePanels()
//        DopamineKit.track("viewBreatheNow")
//    }
//    
//    func presentTutorialViewController() {
//        if !(centerNavigationController.topViewController is TutorialViewController) {
//            centerNavigationController?.pushViewController(TutorialViewController.instance(), animated: true)
//            DopamineKit.track("viewTutorial")
//        }
//        collapseSidePanels()
//    }
//    
//    func presentFeedbackEmail() {
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        } else {
//            self.showSendMailErrorAlert()
//        }
//    }
//    
//    func presentAboutViewController() {
//        centerNavigationController.pushViewController(AboutViewController.instance(), animated: true)
//        collapseSidePanels()
//        
//        DopamineKit.track("viewAboutUs")
//    }
//    
//    func presentShareActivity() {
//        let text = "I'm using Space 🚀 to get some breathing room from addictive apps 💨📱You should try it!\n www.youjustneedspace.com"
//        
//        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
//        
//        self.present(activityViewController, animated: true, completion: nil)
//        DopamineKit.track("shareSpace")
//    }
    
}

extension ContainerViewController : MFMailComposeViewControllerDelegate {
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["team@usedopamine.com"])
        mailComposerVC.setSubject("Space for iOS: Feedback")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    func handleTap() {
        if (currentState != .Collapsed) {
            collapseSidePanels()
        }
    }
}
