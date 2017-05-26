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
        rewardPicker.selectRow(UserDefaults.standard.integer(forKey: "RewardType"), inComponent: 0, animated: false)
        let tapRecoginzer = UITapGestureRecognizer.init(target: self, action: #selector(test))
        tapRecoginzer.delegate = self
        tapRecoginzer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecoginzer)
    }
    
    func test(sender: UITapGestureRecognizer? = nil) {
        NSLog("Tap at:\(sender?.location(in: view).debugDescription)")
        if let tap = sender {
            CAEmitterLayer.tapToStars(view: view, tap: tap)
        }
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

extension CAEmitterLayer {
    static func tapToStars(view: UIView, tap: UITapGestureRecognizer) {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = tap.location(in: view)
        
        let cell = CAEmitterCell()
        cell.name = "starEmitter"
        cell.birthRate = 30
        cell.lifetime = 0.3
        cell.spin = CGFloat.pi * 2.0
        cell.spinRange = CGFloat.pi
        cell.velocity = 400
        cell.scale = 0.01
        cell.scaleSpeed = 0.1
        cell.scaleRange = 0.1
        cell.emissionRange = CGFloat.pi * 2.0
        cell.contents = UIImage(named: "star")!.cgImage
        
        emitterLayer.emitterCells = [cell]
        view.layer.addSublayer(emitterLayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            emitterLayer.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                emitterLayer.removeFromSuperlayer()
            }
        }
    }
    
    static func rand(max: UInt32) -> Int {
        return Int(arc4random_uniform(max)+1)
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
        return row==0 ? "BasalGifglia" : "CandyBar"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: 6)
        label.textAlignment = .center
        label.text = self.pickerView(rewardPicker, titleForRow: row, forComponent: component)
        label.backgroundColor = UIColor.lightGray
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "RewardType")
    }
}
