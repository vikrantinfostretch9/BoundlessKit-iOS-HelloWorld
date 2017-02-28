//
//  UIGifgliaView.swift
//  Pods
//
//  Created by Akash Desai on 10/10/16.
//
//

import Foundation

internal class UIGifgliaView: UIImageView {
    
    class var frameworkBundle: Bundle? {
        if let bundleURL = Bundle(for: UIGifgliaView.classForCoder()).url(forResource: "BasalGifglia", withExtension: "bundle") {
            return Bundle(url: bundleURL)
        } else {
            print("SwiftGif: The BasalGifglia framework bundle cannot be found")
            return nil
        }
    }
    
    /// Loads a Gif from the BasalGifglia framework
    ///
    /// - parameters:
    ///     - name: The filename for the gif, without the .gif extension
    ///
    public func loadGif(_ name: String) {
        if let bundle = UIGifgliaView.frameworkBundle {
            let image = UIImage.gif(fromBundle: bundle, withName: name)
            self.image = image
        } else {
            print("SwiftGif: The BasalGifglia bundle cannot be found")
        }
    }
    
    /// Asks the view to calculate and return the size that best fits the specified size based on the size of the stored Gif image.
    /// This method does not resize the receiver.
    ///
    /// - parameters:
    ///     - size: The size for which the view should calculate its best-fitting size.
    ///
    /// - returns: A new size that fits the receiver’s image.
    ///
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if var fittedSize = self.image?.size {
            // Create margins
            var maxSize = size
            let margin: CGFloat = 16
            maxSize.width -= margin
            maxSize.height -= margin
            
            // Scale down size if needed
            if(fittedSize.width > maxSize.width) {
                let factor = maxSize.width / fittedSize.width
                fittedSize = fittedSize.applying(CGAffineTransform(scaleX: factor, y: factor))
            }
            if(fittedSize.height > maxSize.height) {
                let factor = maxSize.height / fittedSize.height
                fittedSize = fittedSize.applying(CGAffineTransform(scaleX: factor, y: factor))
            }
            
            return fittedSize
        } else {
            return self.frame.size
        }
    }
    
}
