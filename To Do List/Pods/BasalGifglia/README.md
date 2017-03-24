# BasalGifglia-iOS

[![CI Status](http://img.shields.io/travis/DopamineLabs/BasalGifglia-iOS.svg?style=flat)](https://travis-ci.org/DopamineLabs/BasalGifglia-iOS)
[![Version](https://img.shields.io/cocoapods/v/BasalGifglia.svg?style=flat)](http://cocoapods.org/pods/BasalGifglia)
[![License](https://img.shields.io/cocoapods/l/BasalGifglia.svg?style=flat)](http://cocoapods.org/pods/BasalGifglia)
[![Platform](https://img.shields.io/cocoapods/p/BasalGifglia.svg?style=flat)](http://cocoapods.org/pods/BasalGifglia)

# What is BasalGifglia?

BasalGifglia is the easiest way to give your users a 💥 of [Dopamine](http://usedopamine.com/).

The [Dopamine API](https://github.com/DopamineLabs/DopamineKit-iOS) improves your app's engagement, retention, and revenue using optimized [reinforcement](https://github.com/DopamineLabs/DopamineKit-iOS#dopaminekitreinforce).
If you want the boost Dopamine will give you, but don't want to design your own reinforcement, use BasalGifglia. 
It releases the perfect GIF at the best targeted moment, optimized to each user to keep them hooked in your app.

<p align="center"><img src="readme/demo.gif" width="320"></p>

## How do I use it?

In your view controller, import `BasalGiflia` and present a `UIGifgliaViewController` with animation set to true.

```swift
import BasalGifglia

class ViewController: UIViewController {
...
	self.present(UIGifgliaViewController(), animated: true, completion: nil)
...
}
```

### Looking for an iOS Example App?
There is an [example app](Example/BasalGifglia.xcworkspace) included within this repo. To run the example project, clone the repo, and run `pod install` from the Example directory first.

# What's with the name?

When [Dopamine](http://dashboard.usedopamine.com/) is released in the [Basal Ganglia](https://en.wikipedia.org/wiki/Basal_ganglia), it cements a behavior in to a habit. What better way to help your users release dopamine than the dankest GIFs?

## Installation
### CocoaPods
 
  1. Install [CocoaPods](http://cocoapods.org) by running the following command in terminal:

        gem install cocoapods

  2. Create a `Podfile` in your Xcode project directory like below:

        use_frameworks!
        
        target '<YourProjectTarget>' do
            pod 'BasalGifglia'
        end
        
    Using terminal, `cd` to your project directory and run `pod install` to build your dependencies.

  3. Start using BasalGifglia!

## Author

Akash Desai, akash@usedopamine.com

## License

BasalGifglia is available under the MIT license. See the LICENSE file for more info.
