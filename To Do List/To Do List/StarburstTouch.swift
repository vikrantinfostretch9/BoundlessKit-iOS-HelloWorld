//
//  StarburstTouch.swift
//  To Do List
//
//  Created by Akash Desai on 5/28/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIView {
    func showStarburst(at location:CGPoint) {
        let stars = CAEmitterLayer(starburstLayerAt: location)
        layer.addSublayer(stars)
        Helper.playStarSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            stars.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                stars.removeFromSuperlayer()
            }
        }
    }
}

class UIButtonWithStarburstOnClick : UIButton {
    var enableStarburst = true
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if enableStarburst, isTouchInside,
            let touch = touches.first {
            showStarburst(at: touch.location(in: self))
        }
        super.touchesEnded(touches, with: event)
    }
}

extension CAEmitterLayer {
    convenience init(starburstLayerAt location:CGPoint) {
        self.init()
        emitterPosition = location
        
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
        
        emitterCells = [cell]
    }
}
