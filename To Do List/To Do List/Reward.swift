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


enum Reward : String {
    case
    basalGifglia = "📲\t\t Basal Gifglia",
    candyBar = "📲\t\tCandy Bar",
    balloons = "📲\t\t Balloons",
    starSingle = "📲\t\t Stickers",
    goldenFrame = "📲📣🖼 Framed Memory",
    starBurst = "👆📣\t Star Bursts",
    coins = "👆📣📳 Golden Touch",
    confetti = "📲🎊\t Confetti"

    static func rewardsFor(type: RewardType) -> [Reward]! {
        switch type {
        case .newTask:
            return newTaskRewards
        case .doneTask:
            return doneTaskRewards
        case .allDoneTask:
            return allDoneTaskRewards
        }
    }
    
    static let newTaskRewards = [
        Reward.starBurst,
        Reward.coins,
    ]
    static let doneTaskRewards = [
        Reward.basalGifglia,
        Reward.candyBar,
        Reward.balloons,
        Reward.starSingle,
        Reward.starBurst,
        Reward.coins,
        Reward.confetti
    ]
    static let allDoneTaskRewards = [
        Reward.goldenFrame,
        Reward.balloons,
    ]
    static let activeRewardsDefaults = [
        RewardType.newTask.rawValue : Reward.coins.rawValue,
        RewardType.doneTask.rawValue : Reward.balloons.rawValue,
        RewardType.allDoneTask.rawValue : Reward.goldenFrame.rawValue,
        ]
    
    static func getActive(for type: RewardType) -> Reward {
        if let activeRewards = UserDefaults.standard.dictionary(forKey: "ActiveRewards"),
            let activeRewardString = activeRewards[type.rawValue] as? String,
            let activeReward = Reward(rawValue: activeRewardString)
        {
            return activeReward
        } else {
            UserDefaults.standard.set(activeRewardsDefaults, forKey: "ActiveRewards")
            return Reward(rawValue: activeRewardsDefaults[type.rawValue]!)!
        }
    }
    
    static func getActiveIndex(for type: RewardType) -> Int {
        let activeReward = getActive(for: type)
        switch type {
        case .newTask:
            return newTaskRewards.index(of: activeReward) ?? 0
        case .doneTask:
            return doneTaskRewards.index(of: activeReward) ?? 0
        case .allDoneTask:
            return allDoneTaskRewards.index(of: activeReward) ?? 0
        }
    }
    
    static func setActive(for type: RewardType, to reward: Reward) {
        if let activeRewards = UserDefaults.standard.dictionary(forKey: "ActiveRewards") {
            var newRewards = activeRewards
            newRewards[type.rawValue] = reward.rawValue
            UserDefaults.standard.set(newRewards, forKey: "ActiveRewards")
        }
    }
    
    static func colorForIndex(for rewardType: RewardType, and index: Int) -> UIColor{
        let maxIndex: CGFloat
        switch rewardType {
        case .newTask:
            maxIndex = CGFloat(newTaskRewards.count)
        case .doneTask:
            maxIndex = CGFloat(doneTaskRewards.count)
        case .allDoneTask:
            maxIndex = CGFloat(allDoneTaskRewards.count)
        }
        
        let val = CGFloat(index) / maxIndex * (182.0/255.0)
        return UIColor(red: val, green: 66.0/255.0, blue: 244.0/255.0, alpha: 0.7)
    }
}
