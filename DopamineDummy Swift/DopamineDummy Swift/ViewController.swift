//
//  ViewController.swift
//  DopamineDummy Swift
//
//  Created by Akash Desai on 5/19/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import DopamineKit

class ViewController: UIViewController, ReinforcementModalPresenterDelegate {
    
    func action1Performed(){
        // Now reinforce the action and make it sticky!!
        DopamineKit.reinforce("action1", metaData: ["key":"value"], secondaryIdentity: "Bob", callback: {response in
            dispatch_async(dispatch_get_main_queue(), {
                
                // Show reinforcement decision on screen
                self.responseLabel.text = response
                self.flash(self.responseLabel)
                
                
                
                
              //  /* Using Designer Reinforcements
                // Create dopamine designer reinforcement
                var reinforcerType:DesignerReinforcementType
                switch(response!){
                case "awesomeRewardOne":
                    reinforcerType = .NyanCat
                    break
                case "encouragingRewardTwo":
                    reinforcerType = .Cake
                    break
                case "delightfulRewardThree":
                    reinforcerType = .Star
                    break
                default:
                    // Your original app response method once a user has done the action goes here.
                    // Note: You should also add your original app response method as a callback to the DopamineKit ReinforcementModalPresenter by inheriting from ReinforcementModalPresenterDelegate
                    return
                }
                
                // Create the ReinforcementModalPresenter
                let vc = DopamineKit.createReinforcement(reinforcerType)
                
                // Assign self as delegate so the didDismissReinforcement() method gets called when the reinforcement is dismissed
                vc.delegate = self
                
                
                // Present the ReinforcementModalPresenter
                vc.show(self, animated: true)
                 
 
                
            })
        })
    }
    
    func action2Performed(){
        // Tracking call is sent asynchronously
        DopamineKit.track("action2", callback: {response in
            dispatch_async(dispatch_get_main_queue(), {
                // Note: the HTTP status code is returned in a .track() callback as a string
                self.responseLabel.text = "Action was tracked with status \(response!)"
                self.flash(self.responseLabel)
            })
            
        })
        
        // Your original app logic after action2 has been performed
        // ...
        
    }
    
    
    // Implement this method to call your original next UX method
    func didDismissReinforcement(sender: ReinforcementModalPresenter) {
        NSLog("Inheriting from the Delegate class lets you integrate with Dopamine without making changes to your UX!")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBasicUI()
    }
    
    var responseLabel:UILabel = UILabel()
    var action1Button:UIButton = UIButton()
    var trackedActionButton:UIButton = UIButton()
    
    func loadBasicUI(){
        let viewSize = self.view.frame.size
        let viewCenter = self.view.center
        
        // Dopamine icon
        let frameworkBundle = NSBundle(identifier: "com.DopamineLabs.DopamineKit")
        let dopamineIcon = UIImage(named: "Dopamine", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
        let imageView = UIImageView(image: dopamineIcon)
        imageView.center = CGPointMake(viewSize.width/2, 100)
        self.view.addSubview(imageView)
        
        // Response label
        responseLabel = UILabel.init(frame: CGRectMake(0, 150, viewSize.width, 50))
        responseLabel.text = "Click a button below!"
        responseLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(responseLabel)
        
        // Reinforced action button
        action1Button = UIButton.init(frame: CGRectMake(0, 0, viewSize.width/3, viewSize.width/6+10))
        action1Button.center = CGPointMake(viewSize.width/4, viewCenter.y)
        action1Button.layer.cornerRadius = 5
        action1Button.setTitle("User performed action1", forState: UIControlState.Normal)
        action1Button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        action1Button.titleLabel?.textAlignment = NSTextAlignment.Center
        action1Button.backgroundColor = UIColor.init(red: 51/255.0, green: 153/255.0, blue: 51/255.0, alpha: 1.0)
        action1Button.addTarget(self, action: #selector(ViewController.action1Performed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(action1Button)
        
        // Tracked action button
        trackedActionButton = UIButton.init(frame: CGRectMake(0, 0, viewSize.width/3, viewSize.width/6+10))
        trackedActionButton.center = CGPointMake(viewSize.width/4*3, viewCenter.y)
        trackedActionButton.layer.cornerRadius = 5
        trackedActionButton.setTitle("User performed action2", forState: UIControlState.Normal)
        trackedActionButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        trackedActionButton.titleLabel?.textAlignment = NSTextAlignment.Center
        trackedActionButton.backgroundColor = UIColor.init(red: 204/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        trackedActionButton.addTarget(self, action: #selector(ViewController.action2Performed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(trackedActionButton)
        
        
    }
    
    func flash(elm:UIView){
        elm.alpha = 0.0
        UIView.animateWithDuration(0.75, delay: 0.0, options: [.CurveEaseInOut, .AllowUserInteraction], animations: {() -> Void in
            elm.alpha = 1.0
            }, completion: nil)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}

