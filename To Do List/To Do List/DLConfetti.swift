//
//  DLConfetti.swift
//  To Do List
//
//  Created by Akash Desai on 9/27/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

enum ConfettiShape : Int {
    case rectangle, circle, spiral
}


extension UIView {
    /**
     Creates a CAEmitterLayer that drops celebration confetti from the top of the view
     
     - parameters:
     - duration: How long celebration confetti should last
     - size: Size of individual confetti pieces
     - shapes: This directly affects the quantity of confetti. For example, [.circle] will show half as much confetti as [.circle, .circle]
     - colors: Confetti colors are randomly selected from this array. Repeated colors increase that color's likelihood
     */
    func showConfetti(duration:Double = 2.0,
                      size:CGSize = CGSize(width: 15, height: 10),
                      shapes:[ConfettiShape] = [.rectangle, .circle, .spiral],
                      colors:[UIColor] = [UIColor.blue, UIColor.green, UIColor.yellow, UIColor.red, UIColor.red] ) {
        
        let confettiEmitter = CAEmitterLayer(emitterWidth: self.frame.width, confettiSize: size, confettiShapes: shapes, confettiColors: colors)
        self.layer.addSublayer(confettiEmitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            confettiEmitter.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                confettiEmitter.removeFromSuperlayer()
            }
        }
    }
}

fileprivate extension CAEmitterLayer {
    convenience init(emitterWidth: CGFloat, confettiSize:CGSize, confettiShapes:[ConfettiShape], confettiColors:[UIColor]) {
        self.init()
        
        self.emitterPosition = CGPoint(x: emitterWidth / 2.0, y: 0)
        self.emitterShape = kCAEmitterLayerLine
        self.emitterSize = CGSize(width: emitterWidth, height: 1)
        
        var cells:[CAEmitterCell] = []
        if confettiShapes.count > 0 {
            for color in confettiColors {
                let cell = CAEmitterCell()
                
                cell.birthRate = 2
                cell.lifetime = 7.0
                cell.lifetimeRange = 0
                cell.velocity = 200
                cell.velocityRange = 50
                cell.emissionLongitude = CGFloat.pi
                cell.emissionRange = CGFloat.pi / 4
                cell.spin = 2
                cell.spinRange = 3
                cell.scaleRange = 0.5
                cell.scaleSpeed = -0.05
                cell.contents = makeRandomConfetti(size: confettiSize, color: color, shapes: confettiShapes).cgImage!
                
                cells.append(cell)
            }
        }
        
        self.emitterCells = cells
    }
    
    fileprivate func makeRandomConfetti(size:CGSize, color: UIColor, shapes:[ConfettiShape]) -> UIImage {
        let randomIndex: Int = Int(arc4random_uniform(UInt32(shapes.count)))
        
        switch shapes[randomIndex] {
        case .rectangle:
            return rectangleConfetti(size: size, color: color)
        case .circle:
            return circleConfetti(size: size, color: color)
        case .spiral:
            return spiralConfetti(size: size, color: color)
        }
    }
    
    fileprivate func rectangleConfetti(size: CGSize, color: UIColor) -> UIImage {
        let offset = size.width / 8.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        color.set()
        context.beginPath()
        context.move(to: CGPoint(x:offset, y: 0))
        context.addLine(to: CGPoint(x: size.width, y: 0))
        context.addLine(to: CGPoint(x: size.width - offset, y: size.height))
        context.addLine(to: CGPoint(x: 0, y: size.height))
        context.closePath()
        context.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    fileprivate func spiralConfetti(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        /// S-Shape
        color.set()
        let lineWidth:CGFloat = size.width / 8.0
        let halfLineWidth = lineWidth / 2.0
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.move(to: CGPoint(x: halfLineWidth, y: halfLineWidth))
        context.addCurve(to: CGPoint(x: size.width - halfLineWidth, y: size.height - halfLineWidth), control1: CGPoint(x: 0.25*size.width, y: size.height), control2: CGPoint(x: 0.75*size.width, y: 0))
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    fileprivate func circleConfetti(size: CGSize, color: UIColor) -> UIImage {
        let diameter = min(size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        color.set()
        context.fillEllipse(in: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
