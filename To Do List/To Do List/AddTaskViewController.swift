//
//  AddTaskViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
//import DopamineKit

class AddTaskViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var container: ContainerViewController? = nil
    
    @IBOutlet var textTask: UITextField!
    @IBOutlet var textDescription: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var addDemoTasksButton: UIButton!
    
    static func instance() -> AddTaskViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTaskButton.stylizeButton()
        addDemoTasksButton.stylizeButton()
        
//        DopamineConfiguration._temporary?.reinforcementEnabled = false
//        DopamineConfiguration._temporary?.consoleLoggingEnabled = false
    }
    
    @IBAction func  btnAddTask_click(_ sender: UIButton, event: UIEvent){
        taskManager.addTask(textTask.text!, additionalText: textDescription.text!)
        //  self.view.endEditing(true)
        //  tabBarController?.selectedIndex = 0
        textTask.text = ""
        textDescription.text = ""
        
        DispatchQueue.main.async {
//        sender.showGrow()
        }
        
//        if let touch = event.touches(for: sender)?.first {
//            reinforceAddTaskAction(view: sender, point: touch.location(in: sender))
//        }
    }
    
    func reinforceAddTaskAction(view: UIView, point: CGPoint) {
//        DopamineKit.reinforce("action1", completion: {reinforcement in
//            // NOTE: rearranged cases to have rewards show more often for demonstration
////            switch(reinforcement){
////            case "stars" :
////                fallthrough
////            case "thumbsUp" :
////                return
////            default:
//////                switch (Reward.getActive(for: .newTask)) {
//////                case .starBurst:
//////                    view.showEmojiSplosion(at: CGPoint.init(x: self.addTaskButton.bounds.width/2, y: self.addTaskButton.bounds.height/2), lifetime: 1.4, fadeout: 2.0, quantity: 2, bursts: 1.5)
//////                case .coins:
//////                    view.showCoins(at: point)
//////                case .shake:
//////                    view.shake()
//////                case .sheen:
//////                    view.showSheen()
//////                case .glow:
//////                    view.showGlow()
//////                default:
//////                    return
//////                }
////            }
//        })
    }
    
    @IBAction func btnAddDemo_click(_ sender: UIButton){
        taskManager.addDemo()
        container?.collapseSidePanels()
    }
    
    /* ////////////////////////////
     //
     // UITextFieldDelegate
     //
     */ ////////////////////////////
    //    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    //        // dismisses keyboard
    //        textField.resignFirstResponder()
    //        return true
    //    }
    
    // touch out to exit editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    func showTutorial(tableViewController: ToDoListViewController, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            // Setup
            self.container?.addLeftPanelViewController()
            // Animate
            UIView.animate(withDuration: 2.2, delay: 0.5, options: .curveEaseOut, animations: {
                self.container?.animateLeftPanel(shouldExpand: true)
            }) { success in
                // Message
                tableViewController.presentTutorialAlert(title: "Reinforced Action (3/3)", message: "Add a new task here!\n\nDopamineKit can be used to reinforce any habit-forming action.") {
                    // Breakdown
                    UIView.animate(withDuration: 2.2, delay: 1.5, options: .curveEaseIn, animations: {
                        self.container?.animateLeftPanel(shouldExpand: false)
                    }, completion: {success in
                        completion()
                    })
                }
            }
        }
    }
}

extension UIButton {
    func stylizeButton(borderColor: CGColor = UIColor.white.cgColor, borderWidth: CGFloat = 1.0, cornerRadius: CGFloat = 10.0) {
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
//        self.backgroundColor = taskManager.colorForIndex(taskManager.tasks.count/2)
        self.backgroundColor = Helper.dopeGreen.withAlphaComponent(1.85) // UIColor.lightGray.withAlphaComponent(0.2)
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
