//
//  UIImage+Gif.swift
//  Pods
//
//  Created by Arne Bahlo on 07/06/14 and Modified by Akash Desai on 10/11/16.
//
//

import Foundation
import ImageIO
import UIKit

public extension UIImage {
    
    /// Creates an animated UIImage for a Gif
    ///
    /// - parameters:
    ///     - bundle: The bundle the Gif is contained in.
    ///     - name: The name of the Gif, excluding the .gif extension
    ///
    /// - returns: An animated UIImage, or `nil` if no Gif was found
    ///
    public class func gif(fromBundle bundle: Bundle, withName name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = bundle.url(forResource: name, withExtension: "gif") else {
            print("UIGifglia: The image named \"\(name)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("UIGifglia: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        // Create source from data
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            print("UIGifglia: Source for the image named \"\(name)\" does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    /// Extracts the delay times for each image in a Gif
    ///
    private static func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        let defaultDelay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return defaultDelay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        return delayObject as? Double ?? defaultDelay
    }
    
    private static func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    private static func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    private static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill images and delays arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // Add delay
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms to figure out gcd
        }
        
        // Create frames for animation
        let gcd = gcdForArray(delays) // in case frames have variable delays
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Calculate total duration
        var duration: Int = 0
        for delay: Int in delays {
            duration += delay
        }
        
        // Create animated image
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
