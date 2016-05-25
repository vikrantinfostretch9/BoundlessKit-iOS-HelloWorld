
//
//  DataViewController.swift
//  DopamineDummy Swift
//
//  Created by Akash Desai on 4/15/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import DopamineKit

extension DataViewController : ReinforcementModalPresenterDelegate{
    func didDismissReinforcement(sender: ReinforcementModalPresenter) {
        NSLog("Delegate dismiss action")
//        self.buttonReinforce.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        
    }
}

class DataViewController: UIViewController {
    @IBOutlet weak var buttonReinforce: UIButton!

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""

    @IBOutlet weak var responseLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
        
        
    }
    
    @IBAction func trackButton(sender: AnyObject) {
        
        DopamineKit.track("some action")
        self.responseLabel.text = "Tracked"
    }
    
    
    // Yo! Modify this if you want to do something different other than closing the reinforcer
    func reinforcerClicked(gestureRecognizer: UIGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func reinforceButton(sender: AnyObject) {
        // private app logic
        
        // Try it out and modify yourself with "action2"!
        
        
        DopamineKit.reinforce("action1", metaData: ["key":"value"], secondaryIdentity: "Matt", callback: {response in
            dispatch_async(dispatch_get_main_queue(), {
                
                // Show reinforcement decision on screen
                self.responseLabel.text = response
                
                // Create dopamine designer reinforcement
                var reinforcerType = String()
                switch(response!){
                    case "awesomeRewardOne":
                        reinforcerType = "Beast"
                        break
                    case "encouragingRewardTwo":
                        reinforcerType = "Cake"
                        break
                    case "delightfulRewardThree":
                        reinforcerType = "Star"
                        break
                default:
                        return
                }
                
                let vc = DopamineKit.createReinforcement(.Star, reinforcementTitle: "Great job!", reinforcementSubtitle: "Second line", dimBackground: true)
                
                
//                // Create the DopeReinforcementViewController
////                let vc = DopamineKit.createReinforcement(reinforcerType, dimBackground: true)
//                let vc = UIViewController()
////                let meme = MemeView(type: .SuccessKid, frame: CGRectMake(10, 90, 300, 300), topText: "Test test test test", bottomText: "Your mother words words")
//                let meme = DesignerReinforcementView(frame:self.view.frame, type: .Star, primaryText: "Great job!", secondaryText: "nothing", closeText: "Close")
//                vc.view.backgroundColor = UIColor.clearColor()
//                vc.view.addSubview(meme)
//                meme.center = vc.view.center
                
//                let frameworkBundle = NSBundle(identifier: "com.DopamineLabs.DopamineKit")
//                let oimage = UIImage(named: "Ancient Aliens-Blank", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)!
//                meme.image = oimage
                
//                meme.topString = NSAttributedString(string: "changed", attributes: meme.defaultStringAttributes())
                
//                meme.size = CGSize(width: 100, height: 100)
                
                // Assign self as delegate for callback functionality
                // Make sure to set delegate if you want to have a callback!
//                vc.delegate = self
                
                // Present the DopeReinforcementViewController
                // A close button is standard on all designer reinforcements
                
                
                vc.show(self)
                
            })
        })
    }
    


}

