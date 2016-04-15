//
//  DataViewController.swift
//  DopamineDummy Swift
//
//  Created by Akash Desai on 4/15/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit
import DopamineKit

class DataViewController: UIViewController {

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
//        dispatch_async(dispatch_get_main_queue(), {
        self.responseLabel.text = "Tracked"
//        })
    }
    @IBAction func reinforceButton(sender: AnyObject) {
        DopamineKit.reinforce("action1", metaData:["key":"value"], secondaryIdentity: "user", callback: {response in
            dispatch_async(dispatch_get_main_queue(), {
                self.responseLabel.text = response
            })
        })
    }
    
    
    


}

