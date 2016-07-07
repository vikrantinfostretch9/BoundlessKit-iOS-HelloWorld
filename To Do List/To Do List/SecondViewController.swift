//
//  SecondViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textTask: UITextField!
    @IBOutlet var textDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /* ////////////////////////////
     //
     // UITextFieldDelegate
     //
     */ ////////////////////////////
    internal func textFieldShouldReturn(textField: UITextField) -> Bool{
        // dismisses keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func  btnAddTask_click(sender: UIButton){
        taskManager.addTask(textTask.text!, additionalText: textDescription.text!)
        self.view.endEditing(true)
        textTask.text = ""
        textDescription.text = ""
        
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func btnAddDemo_click(sender: UIButton){
        taskManager.addDemo()
        
        tabBarController?.selectedIndex = 0
    }
    
    
    // touch out to exit editing
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


}

