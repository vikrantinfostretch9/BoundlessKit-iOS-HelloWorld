//
//  Helper.swift
//  To Do List
//
//  Created by Akash Desai on 5/26/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

enum RewardType : Int {
    case basalGifglia, candyBar, starBurst
    
    static var count: Int { get { return 3 } }
    
    static func get() -> RewardType {
        guard UserDefaults.standard.value(forKey: "RewardType") != nil else {
            return .starBurst
        }
        return RewardType(rawValue: UserDefaults.standard.integer(forKey: "RewardType")) ?? .basalGifglia
    }
    
    static func set(rawValue: Int) {
        UserDefaults.standard.set(rawValue, forKey: "RewardType")
    }
}

class Helper {
    
}

