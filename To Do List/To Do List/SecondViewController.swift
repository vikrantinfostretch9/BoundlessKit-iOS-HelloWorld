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
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var rewardPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardPicker.dataSource = self
        rewardPicker.delegate = self
    }

    /* ////////////////////////////
     //
     // UITextFieldDelegate
     //
     */ ////////////////////////////
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // dismisses keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func  btnAddTask_click(_ sender: UIButton){
        taskManager.addTask(textTask.text!, additionalText: textDescription.text!)
        self.view.endEditing(true)
        textTask.text = ""
        textDescription.text = ""
        
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func btnAddDemo_click(_ sender: UIButton){
        taskManager.addDemo()
        
        tabBarController?.selectedIndex = 0
    }
    
    
    // touch out to exit editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

extension SecondViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row.description
    }
}
