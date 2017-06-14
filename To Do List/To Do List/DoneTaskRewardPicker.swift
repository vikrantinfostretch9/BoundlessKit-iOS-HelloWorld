//
//  DoneTaskRewardPicker.swift
//  To Do List
//
//  Created by Akash Desai on 6/10/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit


class DoneTaskRewardPicker : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Reward.doneTaskRewards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch RewardType(rawValue: row)! {
//        case .basalGifglia:
//            return "📲\t\t Themed Memes"
//        case .candyBar:
//            return "📲\t\t In-app Motivation"
//        case .balloons:
//            return "📲\t\t Balloons"
//        case .starSingle:
//            return "📲\t\t Sticker Pack"
//        case .goldenFrame:
//            return "📲📣🖼 DopeMemory™"
//        case .starBurst:
//            return "👆📣\t Star Touch"
//        case .coins:
//            return "👆📣📳 Golden Touch"
//        }
//        return Reward.doneTaskRewards[row].rawValue
        return "Test"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: UIFont.systemFontSize)
        label.textAlignment = .left
        label.text = "test"// Reward.doneTaskRewards[row].rawValue // self.pickerView(rewardPicker, titleForRow: row, forComponent: component)
//        label.backgroundColor = RewardType.colorForIndex(index: row)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Reward.setActive(for: .doneTask, to: Reward.allDoneTaskRewards[row])
    }
}
