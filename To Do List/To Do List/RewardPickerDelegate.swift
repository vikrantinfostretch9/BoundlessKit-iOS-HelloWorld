//
//  RewardPickerDelegate.swift
//  To Do List
//
//  Created by Akash Desai on 6/14/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

class RewardPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let rewardType: RewardType
    
    init(type: RewardType) {
        rewardType = type
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Reward.rewardsFor(type: rewardType).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Reward.rewardsFor(type: rewardType)[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: UIFont.systemFontSize)
        //        label.textAlignment = .left
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        label.backgroundColor = Reward.colorForIndex(for: rewardType, and: row)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Reward.setActive(for: rewardType, to: Reward.rewardsFor(type: rewardType)[row])
    }
    
}
