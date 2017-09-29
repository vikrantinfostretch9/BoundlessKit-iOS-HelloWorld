//
//  DLShake.swift
//  To Do List
//
//  Created by Akash Desai on 9/28/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

fileprivate class ShakeAnimationDelegate : NSObject, CAAnimationDelegate {
    let completionHandler: ()->Void
    init(completion: @escaping ()->Void) {
        completionHandler = completion
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completionHandler()
        }
    }
}

public extension UIView {
    
    func testHeartbeat() {
        let duration: TimeInterval = 0.86
        let zoom: CGFloat = 1.0
        zoomInWithEasing(duration: duration, easingOffset: zoom) {
            self.zoomInWithEasing(duration: duration, easingOffset: zoom)
        }
    }
    
    func testTaunt() {
        zoomInWithEasing(duration: 1.0, easingOffset: 0.5, inflection: {inflectionCompletion in
            self.shake(for: 0.3) {
                inflectionCompletion()
            }
        })
    }
    
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
        animation.delegate = ShakeAnimationDelegate(completion: completion)
        
        layer.add(animation, forKey: "shake")
    }
}

//rotate: https://www.andrewcbancroft.com/2014/10/15/rotate-animation-in-swift/
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

//zoom http://stackoverflow.com/questions/31320819/scale-uibutton-animation-swift
extension UIView {
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2, inflection: @escaping (@escaping ()->Void)->Void = {inflectionCompletion in inflectionCompletion()}, completion: @escaping ()->Void = {}) {
//        let oldShadowColor = self.layer.shadowColor
//        let oldShadowOpacity = self.layer.shadowOpacity
//        let oldShadowOffset = self.layer.shadowOffset
//        let oldShadowRadius = self.layer.shadowRadius
        
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        print("duration:\(duration) \neasingOffset:\(easingOffset) \neaseScale:\(easeScale) \neasingDuration:\(easingDuration) \nscalingDuration:\(scalingDuration)")
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
//            
//            self.layer.shadowColor = UIColor.darkGray.cgColor
//            self.layer.shadowOpacity = 0.8
//            self.layer.shadowOffset = CGSize(width: 10, height: 10)
//            self.layer.shadowRadius = 2
        }, completion: { completed in
            inflection() {
                UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity
//                    
//                    self.layer.shadowColor = oldShadowColor
//                    self.layer.shadowOpacity = oldShadowOpacity
//                    self.layer.shadowOffset = oldShadowOffset
//                    self.layer.shadowRadius = oldShadowRadius
                }, completion: { completed in
                    completion()
                })
            }
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { completed in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { completed in
            })
        })
    }
    
}
