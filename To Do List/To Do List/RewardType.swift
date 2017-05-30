//
//  RewardType.swift
//  To Do List
//
//  Created by Akash Desai on 5/28/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

enum RewardType : Int {
    case basalGifglia, candyBar, balloons, starSingle, goldenFrame, starBurst, coins
    
    static var count: Int { get { return 7 } }
    
    static func get() -> RewardType {
        guard UserDefaults.standard.value(forKey: "RewardType") != nil else {
            return .balloons
        }
        return RewardType(rawValue: UserDefaults.standard.integer(forKey: "RewardType")) ?? .basalGifglia
    }
    
    static func set(rawValue: Int) {
        UserDefaults.standard.set(rawValue, forKey: "RewardType")
    }
    
    static func colorForIndex(index: Int) -> UIColor{
        let val = CGFloat(index) / CGFloat(RewardType.count - 1) * (182.0/255.0)
        return UIColor(red: val, green: 66.0/255.0, blue: 244.0/255.0, alpha: 0.7)
    }
}
