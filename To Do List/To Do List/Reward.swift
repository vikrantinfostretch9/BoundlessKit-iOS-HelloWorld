//
//  RewardType.swift
//  To Do List
//
//  Created by Akash Desai on 5/28/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

enum RewardType : String {
    case newTask, doneTask, allDoneTask
}

enum Reward : String {
    case basalGifglia, candyBar, balloons, starSingle, goldenFrame, starBurst, coins
    
    static var newTaskRewards = [Reward.starBurst]
    static var doneTaskRewards = [Reward.candyBar,
                                  Reward.balloons,
                                  Reward.starSingle,
                                  Reward.starBurst
                                  ]
    static var allDoneTaskRewards = [Reward.goldenFrame]
    
    static func getActive(for type: RewardType) -> Reward {
        if let activeRewards = UserDefaults.standard.dictionary(forKey: "ActiveRewards"),
            let activeReward = activeRewards[type.rawValue]
             {
                return activeReward as! Reward
        } else {
            let activeRewardsDefaults = [RewardType.newTask.rawValue : Reward.coins,
                                         RewardType.doneTask.rawValue : Reward.balloons,
                                         RewardType.allDoneTask.rawValue : Reward.goldenFrame
            ]
            UserDefaults.standard.set(activeRewardsDefaults, forKey: "ActiveRewards")
            return activeRewardsDefaults[type.rawValue]! as Reward
        }
    }
    
    static func setActive(for type: RewardType, to reward: Reward) {
        if let activeRewards = UserDefaults.standard.dictionary(forKey: "ActiveRewards") {
            var newRewards = activeRewards
            newRewards[type.rawValue] = reward.rawValue
            UserDefaults.standard.set(newRewards, forKey: "ActiveRewards")
        }
    }
    
//    static func colorForIndex(index: Int) -> UIColor{
//        let val = CGFloat(index) / CGFloat(Rewards.count - 1) * (182.0/255.0)
//        return UIColor(red: val, green: 66.0/255.0, blue: 244.0/255.0, alpha: 0.7)
//    }
}
