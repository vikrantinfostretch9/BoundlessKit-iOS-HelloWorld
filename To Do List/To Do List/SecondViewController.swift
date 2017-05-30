//
//  SecondViewController.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var textTask: UITextField!
    @IBOutlet var textDescription: UITextField!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var rewardPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardPicker.dataSource = self
        rewardPicker.delegate = self
        rewardPicker.selectRow(RewardType.get().rawValue, inComponent: 0, animated: false)
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
    
    @IBAction func  btnAddTask_click(_ sender: UIButton, event: UIEvent){
        taskManager.addTask(textTask.text!, additionalText: textDescription.text!)
        self.view.endEditing(true)
        textTask.text = ""
        textDescription.text = ""
        
//        tabBarController?.selectedIndex = 0
        if let touch = event.touches(for: sender)?.first {
            switch RewardType.get() {
            case .coins:
                sender.showCoins(at: touch.location(in: sender))
            default:
                sender.showStarburst(at: touch.location(in: sender))
            }
        }
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
        return RewardType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch RewardType(rawValue: row)! {
        case .basalGifglia:
            return "📲\t\t Themed Memes"
        case .candyBar:
            return "📲\t\t In-app Motivation"
        case .balloons:
            return "📲\t\t Balloons"
        case .starSingle:
            return "📲\t\t Sticker Pack"
        case .goldenFrame:
            return "📲📣🖼 DopeMemory™"
        case .starBurst:
            return "👆📣\t Star Touch"
        case .coins:
            return "👆📣📳 Golden Touch"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: UIFont.systemFontSize)
        label.textAlignment = .left
        label.text = self.pickerView(rewardPicker, titleForRow: row, forComponent: component)
        label.backgroundColor = RewardType.colorForIndex(index: row)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        RewardType.set(rawValue: row)
    }
}
