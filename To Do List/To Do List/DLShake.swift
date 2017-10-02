//
//  DLShake.swift
//  To Do List
//
//  Created by Akash Desai on 9/28/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

fileprivate class CoreAnimationDelegate : NSObject, CAAnimationDelegate {
    
    let willStart: (()->Void)->Void
    let didStart: ()->Void
    let didStop: ()->Void
    
    init(willStart: @escaping (()->Void)->Void = {startAnimation in startAnimation()}, didStart: @escaping ()->Void = {}, didStop: @escaping ()->Void = {}) {
        self.willStart = willStart
        self.didStart = didStart
        self.didStop = didStop
    }
    
    func start(view: UIView, animation:CAAnimation) {
        willStart() {
            animation.delegate = self
            view.layer.add(animation, forKey: nil)
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        didStart()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            didStop()
        }
    }
}

public extension UIView {
    
    func testHeartbeat() {
        let duration: TimeInterval = 0.86
        let scale: CGFloat = 2.0
//        zoomInWithEasing(duration: duration, easingOffset: zoom) {
//            self.zoomInWithEasing(duration: duration, easingOffset: zoom)
//        }
        
        zoom(duration: duration, scale: scale, count: 1, inflection: {completion in completion()})
        
    }
    
//    func testTaunt() {
//        zoomInWithEasing(duration: 1.0, easingOffset: 0.5, inflection: {inflectionCompletion in
//            self.shake(for: 0.3) {
//                inflectionCompletion()
//            }
//        })
//    }
    
    func testAnimation() {
        testHeartbeat()
    }
    
    func shake(count:Float = 2, for duration:TimeInterval = 0.5, withTanslation translation:Float = -5, completion: @escaping ()->Void = {}) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        
//        let _ = CoreAnimationDelegate(willStart: {startAnimation in
//            print("will start")
//            startAnimation()
//        }, didStart: {print("didstart")}, didStop: {print("didstop")})
//        
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = 2.0 * CGFloat.pi
        rotateAnimation.duration = duration
        
        if let delegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

extension UIView {
    
    func zoom(duration: TimeInterval = 0.2, scale: CGFloat = 2.0, count: Int = 1, inflection: @escaping (@escaping ()->Void)->Void = {inflectionCompletion in inflectionCompletion()}, completion: @escaping ()->Void = {}) {
        
        let spring = CASpringAnimation(keyPath: "transform.scale")
//        spring.duration = duration
//        spring.fromValue = 0.5
        spring.toValue = scale
//        spring.autoreverses = true
        spring.initialVelocity = 5.0
//        spring.damping = 1.0
//        spring.mass = 0.1
        
        let animationDelegate = CoreAnimationDelegate(willStart: {startAnimation in
            print("will start")
            startAnimation()
        }, didStart: {print("didstart")}, didStop: {
            print("didstop")
//            let springBack = spring
//            let temp = springBack.fromValue
//            springBack.fromValue = springBack.toValue
//            springBack.toValue = temp
//            let reverseAnimationDelegate = CoreAnimationDelegate()
//            reverseAnimationDelegate.start(view: self, animation: springBack)
        })
        
//        self.layer.add(spring, forKey: "spring")
        
        print("SHould've added")
        animationDelegate.start(view: self, animation: spring)
    }
    
}
