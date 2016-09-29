//
//  CandyIcon.swift
//  Pods
//
//  Created by Akash Desai on 9/28/16.
//
//

import Foundation
import UIKit

@objc
public enum CandyIcon : Int{
    case None = 0, Certificate, Crown, Crown2, MedalStar, RibbonStar, Stars, Stopwatch, ThumbsUp, TrophyHand, TrophyStar, WreathStar
    
    /// The filename for the icon image from the CandyBar framework
    ///
    internal var filename: String{
        switch self{
        case .Certificate: return "certificate"
        case .Crown: return "crown"
        case .Crown2: return "crown2"
        case .MedalStar: return "medalStar"
        case .RibbonStar: return "ribbonStar"
        case .Stars: return "stars"
        case .Stopwatch: return "stopwatchOne"
        case .ThumbsUp: return "thumbsUp"
        case .TrophyHand: return "trophyHand"
        case .TrophyStar: return "trophyStar"
        case .WreathStar: return "wreathStar"
        default: return ""
        }
    }
    
    /// The icon image to be displayed on the left of a CandyBar
    ///
    internal var image: UIImage?{
        
        if let bundleURL = NSBundle(forClass: CandyBar.classForCoder()).URLForResource("CandyIcons", withExtension: "bundle"),
        let bundle = NSBundle.init(URL: bundleURL) {
            return UIImage(named: filename, inBundle: bundle, compatibleWithTraitCollection: nil)
        } else {
            return nil
        }
        
    }
}
