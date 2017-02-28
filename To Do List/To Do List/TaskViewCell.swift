//
//  TaskViewCell.swift
//  To Do List
//
//  Created by Akash Desai on 6/8/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import DopamineKit

// A protocol that the TaskViewCell uses to inform its delegate of state change
protocol TaskViewCellDelegate {
    func taskItemDeleted(_ taskItem: Task)
    func presentReward()
}

class TaskViewCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    
    var tickLabel: UILabel
    
    var delegate: TaskViewCellDelegate?
    // The item that this cell renders.
    var task: Task?
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // tick label for context cue
        tickLabel = TaskViewCell.createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .left
        
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let kUICuesMargin: CGFloat = 0.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        tickLabel.frame = CGRect(x: bounds.size.width+kUICuesMargin, y: 0, width: bounds.size.width-kUICuesMargin, height: bounds.size.height)
    }
    
    // utility method for creating the contextual cues
    static func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 48.0)
        label.backgroundColor = UIColor.green
        return label
    }
    
    
    let dopeGreen = UIColor.init(red: 51/255.0, green: 153/255.0, blue: 51/255.0, alpha: 0.9)
    let dopeRed = UIColor.init(red: 204/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.9)
    let dopeBlue = UIColor.init(red: 51/255.0, green: 102/255.0, blue: 153/255.0, alpha: 0.9)
    let dopeYellow = UIColor.init(red: 255/255.0, green: 204/255.0, blue: 0, alpha: 0.9)
    
    //MARK: - horizontal pan gesture methods
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
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
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            
            // fade context cues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            if(deleteOnDragRelease){
                tickLabel.textColor = dopeGreen
                tickLabel.backgroundColor = UIColor.clear
            } else{
                tickLabel.textColor = UIColor.clear
                tickLabel.backgroundColor = dopeGreen
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
                if delegate != nil && task != nil {
                    
                    // notify the delegate that this item should be deleted
                    delegate!.taskItemDeleted(task!)
                    
                    // The completed task has been deleted
                    // Let's give em some positive reinforcement!
                    DopamineKit.reinforce("action1", completion: {reinforcement in
                        // So we don't run on the main thread
                        DispatchQueue.main.async(execute: {
                            
                            switch(reinforcement){
                            case "thumbsUp" :
                                self.delegate?.presentReward()
                                
                            case "stars" :
                                self.delegate?.presentReward()
                                
                            case "medalStar" :
                                self.delegate?.presentReward()
                                
                            case "neutralResponse" :
                                fallthrough
                            default:
                                // Show nothing! This is called a neutral response, and builds up the good feelings for the next surprise!
                                return
                            }
                        })
                    })
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

}
