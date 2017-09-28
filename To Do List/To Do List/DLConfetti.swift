//
//  DLConfetti.swift
//  To Do List
//
//  Created by Akash Desai on 9/27/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func showConfetti(duration: Double) {
        let confetti = CAEmitterLayer(confettiLayerOn: self, width: 15)
        self.layer.addSublayer(confetti)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            confetti.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                confetti.removeFromSuperlayer()
            }
        }
    }
}

extension CAEmitterLayer {
    convenience init(confettiLayerOn view: UIView, width: CGFloat) {
        self.init()
        
        let height = width * 2.0/3.0
        self.emitterPosition = CGPoint(x: view.frame.size.width / 2.0, y: 0)
        self.emitterShape = kCAEmitterLayerLine
        self.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let colors = [UIColor.blue, UIColor.green, UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.red]
        self.emitterCells = makeConfettiCell(width: width, height: height, colors: colors)
    }
    
    fileprivate func makeConfettiCell(width:CGFloat, height: CGFloat, colors: [UIColor]) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        for color in colors {
            let cell = CAEmitterCell()
            
            //        cell.name = color.
            cell.birthRate = 2
            cell.lifetime = 7.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = 200
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scaleRange = 0.5
            cell.scaleSpeed = -0.05
            cell.contents = randomConfetti(size: CGSize(width: width, height: height), color: color).cgImage
            
            cells.append(cell)
        }
        return cells
    }
    
    fileprivate func randomConfetti(size: CGSize, color: UIColor) -> UIImage {
        switch arc4random_uniform(3) {
        case 0:
            return parallelogramConfetti(size: size, color: color)
        case 1:
            return curvedConfetti(size: size, color: color)
        default:
            return circleConfetti(size: size, color: color)
        }
    }
    
    fileprivate func parallelogramConfetti(size: CGSize, color: UIColor) -> UIImage {
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
    
    fileprivate func curvedConfetti(size: CGSize, color: UIColor) -> UIImage {
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
