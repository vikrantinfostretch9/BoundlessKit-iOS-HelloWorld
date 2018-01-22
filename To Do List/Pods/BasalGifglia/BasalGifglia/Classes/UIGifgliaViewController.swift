//
//  UIGifgliaViewController.swift
//  Pods
//
//  Created by Akash Desai on 10/10/16.
//
//

import Foundation

open class UIGifgliaViewController: UIViewController {
    
    /// Whether the view controller should dismiss itself after `autoDismissTimeout` seconds
    open var autoDismiss = true
    
    /// The time, in seconds, until the view controller should dismiss itself. The time must be >= 0.1 seconds
    open var autoDismissTimeout = 2.5
    
    /// Convenience method to disable auto closing
    ///
    public convenience init(autoDismissEnabled: Bool = true) {
        self.init()
        self.autoDismiss = autoDismissEnabled
    }
    
    /// Convenience method to set auto close timeout
    ///
    public convenience init(autoDismissTimeout: Double = 2.5) {
        self.init()
        self.autoDismissTimeout = autoDismissTimeout
    }
    
    /// The view controller is required to be displayed over the full screen
    /// for the dimming effect
    ///
    open override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .overFullScreen }
        set { print("modalPresentationStyle needs to be .overFullScreen")}
    }
    
    /// The view controller layed over a dimmed UIGifgliaViewController
    let gifViewController = UIViewController()
    
    /// Loads two views into the gifViewController,
    /// one for the Gif and one for a close button
    ///
    override open func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        
        // gif view
        let gifView = UIGifgliaView()
        gifView.loadGif(Gifglia.getNextGif().filename)
        gifView.frame.size = gifView.sizeThatFits(self.view.frame.size)
        
        let gifX: CGFloat = self.view.frame.width / 2 - gifView.frame.width / 2
        let gifY: CGFloat = self.view.frame.height / 2 - gifView.frame.height / 2
        gifView.frame.origin.x = gifX
        gifView.frame.origin.y = gifY
        
        gifView.layer.shadowColor = UIColor.black.cgColor
        gifView.layer.shadowOpacity = 0.6
        gifView.layer.shadowRadius = 15
        gifView.layer.shadowOffset = CGSize(width: 15, height: 15)
        gifView.layer.masksToBounds = false
        
        // close button
        let buttonLength: CGFloat = 16
        let buttonX: CGFloat = gifX + gifView.frame.width - 0.75 * buttonLength
        let buttonY: CGFloat = gifY - 0.25 * buttonLength
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonLength, height: buttonLength)
        if let bundleURL = Bundle(for: UIGifgliaViewController.classForCoder()).url(forResource: "BasalGifglia", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL) {
            let image = UIImage(named: "close button", in: bundle, compatibleWith: nil)
            closeButton.setImage(image, for: UIControlState.normal)
        } else {
            closeButton.setTitle("x", for: UIControlState.normal)
        }
        closeButton.addTarget(self, action: #selector(UIGifgliaViewController.closeGifView), for: .touchUpInside)
        
        gifViewController.view.addSubview(gifView)
        gifViewController.view.addSubview(closeButton)
    }
    
    /// Modally presents a gif and also
    /// dispatches a task to automatically dismiss itself after `autoDismissTimeout` seconds if `autoDismiss` is true
    ///
    override open func viewDidAppear(_ animated: Bool) {
        showGifView()
        if (autoDismiss && autoDismissTimeout >= 0.1) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + autoDismissTimeout) {
                self.closeGifView()
            }
        }
    }
    
    /// Presents the gifViewController modally
    ///
    func showGifView() {
        gifViewController.modalPresentationStyle = .overFullScreen
        gifViewController.modalTransitionStyle = .coverVertical
        self.dim(.in, alpha: 0.7, speed: 0.25)
        self.present(self.gifViewController, animated: true)
    }
    
    /// Dismisses both the gifViewController and the UIGifgliaViewController
    ///
    @objc func closeGifView() {
        DispatchQueue.main.async() {
            self.gifViewController.modalTransitionStyle = .crossDissolve
            self.dismiss(animated: true, completion: nil)
            self.dim(.out, speed: 0.25)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Manually dismiss the UIGifgliaViewController.
    /// Use this method if `autoDismiss` is disabled
    ///
    open func dismissSelf() {
        closeGifView()
    }
    
}


fileprivate extension UIViewController {
    
    /// The direction to fade in or out the dimming effect
    ///
    enum Direction { case `in`, out }
    
    /// Adds a transparent, monochromatic view over for a dimmed effect
    ///
    /// - parameters:
    ///     - direction: Whether to fade the dim in or fade it out.
    ///     - color: The overlaying color. Defaults to black.
    ///     - alpha: The transparency factor. Defaults to 0.
    ///     - speed: The total duration of the animations, measured in seconds. Defaults to 0.
    ///
    func dim(_ direction: Direction, color: UIColor = UIColor.black, alpha: CGFloat = 0.0, speed: Double = 0.0) {
        
        switch direction {
        case .in:
            // Create and add a dim view
            let dimView = UIView(frame: view.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            view.addSubview(dimView)
            
            // Deal with Auto Layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            
            // Animate alpha (the actual "dimming" effect)
            UIView.animate(withDuration: speed, animations: { () -> Void in
                dimView.alpha = alpha
            })
            
        case .out:
            UIView.animate(withDuration: speed, animations: { () -> Void in
                self.view.subviews.last?.alpha = alpha
                }, completion: { (complete) -> Void in
                    // Remove the dim view
                    self.view.subviews.last?.removeFromSuperview()
            })
        }
    }
}
