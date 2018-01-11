//
//  TaskViewCell.swift
//  To Do List
//
//  Created by Akash Desai on 6/8/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
//import DopamineKit
import BasalGifglia

// A protocol that the TaskViewCell uses to inform its delegate of state change
protocol TaskViewCellDelegate {
    func taskItemDeleted(_ taskItem: Task, animation: UITableViewRowAnimation)
    func presentTaskDoneReward(view: UIView, gesture: UIGestureRecognizer)
}

class TaskViewCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    
    var tickLabel: UILabel
    var tickLabelLeft: UILabel
    var swipingRight = false
    
    var delegate: TaskViewCellDelegate?
    // The item that this cell renders.
    var task: Task?
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // tick label for context cue
        tickLabel = TaskViewCell.createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .left
        tickLabelLeft = TaskViewCell.createCueLabel()
        tickLabelLeft.text = "\u{2713}"
        tickLabelLeft.textAlignment = .right
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Gradient effect
        gradientLayer.frame = bounds
        let colorGradient = [UIColor.init(white: 1.0, alpha: 0.2).cgColor as CGColor,
                             UIColor.init(white: 1.0, alpha: 0.1).cgColor as CGColor,
                             UIColor.clear.cgColor as CGColor,
                             UIColor.init(white: 0.0, alpha: 0.1).cgColor as CGColor]
        gradientLayer.colors = colorGradient
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        // pan recognizer
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TaskViewCell.handlePan(_:)))
        panRecognizer.delegate = self
        self.addGestureRecognizer(panRecognizer)
        
        
        addSubview(tickLabel)
        addSubview(tickLabelLeft)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let kUICuesMargin: CGFloat = 0.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        tickLabel.frame = CGRect(x: bounds.size.width+kUICuesMargin, y: 0, width: bounds.size.width-kUICuesMargin, height: bounds.size.height)
        tickLabelLeft.frame = CGRect(x: 0-bounds.size.width-kUICuesMargin, y: 0, width: bounds.size.width-kUICuesMargin, height: bounds.size.height)
    }
    
    // utility method for creating the contextual cues
    static func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 48.0)
        label.backgroundColor = UIColor.green
        return label
    }
    
    static var count = 0
    //MARK: - horizontal pan gesture methods
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = (frame.origin.x < -frame.size.width / 8.0) || (frame.origin.x > frame.size.width / 8.0)
            swipingRight = frame.origin.x > 0
            
            // fade context cues
            tickLabel.alpha = fabs(frame.origin.x) / (frame.size.width / 8.0)
            tickLabelLeft.alpha = fabs(tickLabelLeft.frame.origin.x) / (frame.size.width / 8.0)
            if(deleteOnDragRelease){
                tickLabel.textColor = Helper.dopeGreen
                tickLabel.backgroundColor = UIColor.clear
                tickLabelLeft.textColor = Helper.dopeGreen
                tickLabelLeft.backgroundColor = UIColor.clear
            } else{
                tickLabel.textColor = UIColor.clear
                tickLabel.backgroundColor = Helper.dopeGreen
                tickLabelLeft.textColor = UIColor.clear
                tickLabelLeft.backgroundColor = Helper.dopeGreen
            }
        
        }
        // 3
        
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                if TaskViewCell.count % 2 == 0 {
                ToDoListViewController.shared.present(UIGifgliaViewController(), animated: true, completion: nil)
                }
                TaskViewCell.count = TaskViewCell.count + 1
                if delegate != nil && task != nil {
                    
                    // notify the delegate that this item should be deleted
                    delegate!.taskItemDeleted(task!, animation: swipingRight ? .right : .left)
                    
                    // The completed task has been deleted
                    // Let's give em some positive reinforcement!
//                    DopamineKit.reinforce("action1", completion: {reinforcement in
//                        // So we don't run on the main thread
//                        DispatchQueue.main.async(execute: {
//                            // NOTE: rearranged cases to have rewards show more often for demonstration
//                            switch(reinforcement){
//                            case "thumbsUp" :
////                                fallthrough
//                                return;
//                            case "stars" :
//                                fallthrough
//                            case "medalStar" :
//                                fallthrough
//                            case "neutralResponse" :
//                                self.delegate?.presentTaskDoneReward(view: self.superview!, gesture: recognizer)
//                                NSLog("DopamineKit - Show reward!")
//                            default:
//                                NSLog("wtf is this:\(reinforcement)")
//                                return
//                            }
//                        })
//                    })
                }
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func showTutorial(tableViewController: ToDoListViewController, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            // Setup
            let overlay = TAOverlayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                                      height: UIScreen.main.bounds.height), subtractedPaths: [
                                                        TARectangularSubtractionPath(frame: tableViewController.tableView.frame,
                                                                                     horizontalPadding: 0, verticalPadding: 0)
                ])
            overlay.alpha = 0.0
            tableViewController.view.addSubview(overlay)
            
            // Animate
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {overlay.alpha = TAOverlayView.defaultAlpha}) { _ in
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                    self.center = CGPoint(x: self.center.x - self.frame.size.width / 8.0, y: self.center.y)
                    
                    self.tickLabel.textColor = UIColor.white
                    self.tickLabel.backgroundColor = Helper.dopeGreen
                }) { success in
                    // Message
                    tableViewController.presentTutorialAlert(title: "Reinforced Action (1/3)", message: "Swipe to complete a task!\n\nMaybe you'll receive a reward, maybe you won't.") {
                        // Breakdown
                        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
                            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
                            overlay.alpha = 0.0
                        }, completion: {success in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                overlay.removeFromSuperview()
                                completion()
                            }
                        })
                    }
                }
            }
        }
    }
}
