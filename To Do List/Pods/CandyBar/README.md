# CandyBar-iOS
Simple notification framework that displays an Icon, Title, and Subtitle.

# What is CandyBar?
CandyBar is an alternative notification view. A CandyBar includes an easily customizable icon and text. There are [11 Candy Icons](CandyBar/CandyBar/Resources/CandyIcons.xcassets) provided within the framework, but you could also use your own image.
 
### Looking for an iOS Example App?
There is an [example app](CandyBar/Example/CandyBar.xcworkspace) included within this repo. 
 
 <center><img src="readme/CandyBar on Top.png" width="320">
 <img src="readme/CandyBar on Bottom.png" width="320"></center>
 
## Set up CandyBar
 
  1. In your Podfile, include the CandyBar like below
     
        use_frameworks!
        
        target 'SomeonesApp' do
            pod 'CandyBar'
        end
        
  2. Start using CandyBars! Below are examples of how to use functions provided by the framework.


##### Creating a CandyBar
  ```swift
  // Swift
  let candyBar = CandyBar(title: "You can even use emojis 💯",
                            icon: CandyIcon.Stars,
                            position: .Bottom,
                            backgroundColor: UIColor.purpleColor()
  )
  
  let customCandyBar = CandyBar(title: "Use a custom image!",
                               	image: UIImage(named: "YourImage"),
                               	backgroundColor: CandyBar.hexStringToUIColor("#4286f4"),
                               	didDismissBlock: { NSLog("The user dismissed the CandyBar")}
  )
  ```
  
  ```objective-c
  // Objective-C
  CandyBar* candyBar = [[CandyBar alloc] initWithTitle: @"Whayda go!"
                                              subtitle: nil
                                              position: CandyBarPositionTop
                                                  icon: CandyIconStars
                                       backgroundColor: [CandyBar hexStringToUIColor:@"#E3DE4D"]
                                       didDismissBlock: nil ];
  ```
  
##### Displaying a CandyBar
  ```swift
  // Swift
  candyBar.show(3.2)					// display for 3.2 
  customCandyBar.show()					// dismiss on tap, or 
  // customCandyBar.dismiss()			// programmatically dismiss it using bar.dismiss()seconds
  
  ```
  
  ```objective-c
  // Objective-C
  [customCandyBar show];
  // [customCandyBar dismiss];
  ```
    
# User engagement isn’t luck: it’s science.
The [DopamineAPI](http://usedopamine.com/) boosts your app’s engagement, retention, and revenue using the science of positive reinforcement. Paste in a few lines of our code we’ll figure out - in real time - the perfect moment to give each user their own little 💥 of Dopamine. Powered by state of the art neuroscience and AI: no PhD required. Grab your free account and get started in minutes at [UseDopamine.com](http://usedopamine.com/).