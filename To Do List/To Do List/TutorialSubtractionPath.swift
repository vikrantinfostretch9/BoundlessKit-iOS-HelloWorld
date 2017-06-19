//
//  TutorialSubtractionPath.swift
//  To Do List
//
//  Created by Akash Desai on 6/19/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

/// Creates a subtraction path that is rectangular.
public class TARectangularSubtractionPath: TABaseSubtractionPath {
    /// Total padding applied to the left and the right of ``self.frame``.
    let horizontalPadding: CGFloat
    
    /// Total padding applied to the top and the bottom of ``self.frame``.
    let verticalPadding: CGFloat
    
    /// Use to init the path.
    ///
    /// - parameter frame: The frame of the object to enclose.
    /// - parameter horizontalPadding: Total padding applied to the left and the right of the ``frame``.
    /// - parameter verticalPadding: Total padding applied to the top and the bottom of the ``frame``.
    ///
    public init(frame: CGRect, horizontalPadding: CGFloat = 0, verticalPadding: CGFloat = 0) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        super.init(frame: frame)
    }
    
    /// Creates a rectangular path with the given padding. The frame is centered in the padding.
    fileprivate override func createPath() -> UIBezierPath {
        var rect = self.frame
        
        // Adjust the origin to center the frame in the padding.
        rect.origin.x -= self.horizontalPadding
        rect.origin.y -= self.verticalPadding
        
        // Adjust the width/height for the padding.
        rect.size.width += 2 * self.horizontalPadding
        rect.size.height += 2 * self.verticalPadding
        
        return UIBezierPath(rect: rect)
    }
    
}

/// Creates a subtraction path that is circular.
public class TACircularSubtractionPath: TABaseSubtractionPath {
    
    /// The radius of the circle to subtract.
    let radius: CGFloat
    
    /// Use to init the path.
    ///
    /// - parameter frame: The frame of the object to encircle.
    /// - parameter radius: The radius of the hole. The larger the radius, the larger the hole in the overlay.
    ///
    public init(frame: CGRect, radius: CGFloat = 0) {
        self.radius = radius
        super.init(frame: frame)
    }
    
    /// Creates a circular path with the given radius.
    fileprivate override func createPath() -> UIBezierPath {
        let rect = CGRect(x: self.frame.midX - self.radius, y: self.frame.midY - self.radius,
                          width: 2 * self.radius, height: 2 * self.radius)
        return UIBezierPath(ovalIn: rect)
    }
}



/// Base class to be inherited from when creating new path shapes.
public class TABaseSubtractionPath {
    
    /// The frame of the object that will be visible through the overlay.
    let frame: CGRect
    
    /// The path to be subtracted.
    lazy var bezierPath: UIBezierPath = {
        return self.createPath()
    }()
    
    public init(frame: CGRect) {
        self.frame = frame
    }
    
    /// Creates the path that will be subtracted. Override to customize the shape of the path (circular, rectangular, etc.).
    fileprivate func createPath() -> UIBezierPath {
        return UIBezierPath()
    }
    
}
