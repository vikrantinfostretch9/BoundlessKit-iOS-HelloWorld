//
//  Helper.swift
//  To Do List
//
//  Created by Akash Desai on 5/26/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Helper {
    var starSoundId: SystemSoundID = 0
    var coinSoundId: SystemSoundID = 1
    var photoSoundId: SystemSoundID = 2
    
    fileprivate static let sharedInstance = Helper()
    
    init() {
        if let sound = Bundle.main.url(forResource: "star-sound", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(sound as CFURL, &starSoundId)
        }
        if let sound = Bundle.main.url(forResource: "coin-sound", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(sound as CFURL, &coinSoundId)
        }
        if let sound = Bundle.main.url(forResource: "shoot-and-roll", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(sound as CFURL, &photoSoundId)
        }

    }
    
    static func playStarSound() {
        AudioServicesPlaySystemSound(Helper.sharedInstance.starSoundId)
    }
    
    static func playCoinSound() {
        AudioServicesPlaySystemSound(Helper.sharedInstance.coinSoundId)
    }
    
    static func playPhotoSound() {
        AudioServicesPlaySystemSound(Helper.sharedInstance.photoSoundId)
    }
}

