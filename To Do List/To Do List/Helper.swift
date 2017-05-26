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
        return RewardType(rawValue: UserDefaults.standard.integer(forKey: "RewardType")) ?? .basalGifglia
    }
    
    static func set(rawValue: Int) {
        UserDefaults.standard.set(rawValue, forKey: "RewardType")
    }
}

class Helper {
    static func addStarsFor(view: UIView, tap: UIGestureRecognizer) {
        CAEmitterLayer.tapToStars(view: view, tap: tap)
    }
}

fileprivate extension CAEmitterLayer {
    static func tapToStars(view: UIView, tap: UIGestureRecognizer) {
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
