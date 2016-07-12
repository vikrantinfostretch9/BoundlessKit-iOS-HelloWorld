//
//  Candy.swift
//  DopamineKit
//
//  Created by Akash Desai on 6/2/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

/// Candy is an enumeration of icons that can appear on a CandyBar. Visit UseDopamine.com to see them all visually displayed
@objc
public enum Candy : Int{
    case None = 0, Certificate, Crown, Crown2, MedalStar, RibbonStar, Stars, Stopwatch, ThumbsUp, TrophyHand, TrophyStar, WreathStar
    
    private var DopeAssetName:String?{
        switch self{
        case .None: return nil
        case .Certificate: return "certificate"
        case .Crown: return "crown"
        case .Crown2: return "crown2"
        case .MedalStar: return "medalStar"
        case .RibbonStar: return "ribbonStar"
        case .Stars: return "stars"
        case .Stopwatch: return "stopwatchOne"
        case .ThumbsUp: return "thumbsUp"
        case .TrophyHand: return "trophyHand"
        case .TrophyStar: return "trophyStar"
        case .WreathStar: return "wreathStar"
        }
    }
}

@objc
public class CandyBar: Banner {
    
    /// A CandyBar with the provided `title`, `subtitle`, and an optional `image`, ready to be presented with `show()`.
    ///
    /// - parameter title: The title of the banner. Defaults to nil.
    /// - parameter subtitle: The subtitle of the banner. Defaults to nil.
    /// - parameter image: The image on the left of the banner. Defaults to nil.
    /// - parameter backgroundColor: The color of the banner's background view. Defaults to `UIColor.blackColor()`.
    /// - parameter didTapBlock: An action to be called when the user taps on the banner. Defaults to `nil`.
    public required init(title: String? = nil, subtitle: String? = nil, image: UIImage? = nil, backgroundColor: UIColor = UIColor.blackColor(), didTapBlock: (() -> ())? = nil) {
    
        super.init(title: title, subtitle: subtitle, image: image, backgroundColor: backgroundColor, didTapBlock: didTapBlock)
        
        self.position = .Bottom
    }
    
    /// A CandyBar with the provided `title`, `subtitle`, and an optional icon, ready to be presented with `show()`.
    ///
    /// - parameter title: The title of the banner. Defaults to nil.
    /// - parameter subtitle: The subtitle of the banner. Defaults to nil.
    /// - parameter icon: The icon on the left of the banner. Defaults to .Stars
    /// - parameter backgroundColor: The color of the banner's background view. Defaults to `UIColor.blackColor()`.
    /// - parameter didTapBlock: An action to be called when the user taps on the banner. Defaults to `nil`.
    public required init(title: String? = nil, subtitle: String? = nil, icon: Candy = .Stars, backgroundColor: UIColor = UIColor.blackColor(), didTapBlock: (() -> ())? = nil) {
        
        var retrievedImage:UIImage? = nil
        let frameworkBundle = NSBundle(identifier: "com.UseDopamine.DopamineKit")
        retrievedImage = UIImage(named: icon.DopeAssetName!, inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
        
        
        super.init(title: title, subtitle: subtitle, image: retrievedImage, backgroundColor: backgroundColor, didTapBlock: didTapBlock)
        
        self.position = .Bottom
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// This function takes a hex string and returns a UIColor
    ///
    /// - parameter hex: A hex string with either format `"#ffffff"` or `"ffffff"` or `"#FFFFFF"`
    /// - returns: The corresponding UIColor for valid hex strings, `UIColor.grayColor()` otherwise
    public static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
