//
//  DLBalloons.swift
//  To Do List
//
//  Created by Akash Desai on 5/28/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    fileprivate func showBalloon(width: CGFloat, height: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        let balloonImage = UIImage(named: "three-balloon")!
        let balloonView = UIImageView(image: balloonImage)
        
        let xStart = CGFloat(Helper.rand(max: UInt32(self.frame.maxX)))
        let yStart = self.frame.maxY
        let xEnd = Helper.rand(max: UInt32(self.frame.maxX))
        let yEnd = 0
        let xMid = xEnd / 2
        let yMid = Helper.rand(max: UInt32(self.frame.maxY))
        
        balloonView.frame = CGRect(x: xStart, y: yStart, width: width, height: height)
        self.addSubview(balloonView)
        
        path.move(to: CGPoint(x: xStart,y: yStart))
        path.addQuadCurve(to: CGPoint(x: xEnd, y: yEnd), controlPoint: CGPoint(x: xMid, y: yMid))
        
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = 5.0 - 0.5 * Double(Helper.rand(max: 3))
        animation.fillMode = kCAFillModeRemoved
        balloonView.layer.add(animation, forKey: "random upward path")
    }
    
    func showBalloons() {
        let largestSize = min(frame.width, frame.height) / 3
        let balloonSizes = [largestSize/2, largestSize/2, largestSize/3, largestSize]
        for size in balloonSizes {
            showBalloon(width: size, height: size)
        }
    }
}
