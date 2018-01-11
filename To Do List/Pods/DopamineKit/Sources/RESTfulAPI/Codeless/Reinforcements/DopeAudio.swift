//
//  DopeAudio.swift
//  DopamineKit
//
//  Created by Akash Desai on 11/29/17.
//

import Foundation
import AudioToolbox

internal class DopeAudio : NSObject {
    
    fileprivate static let audioQueue = SingleOperationQueue()
    
    static func play(_ systemSoundID: SystemSoundID = 0 , vibrate: Bool = false) {
        audioQueue.addOperation {
            if systemSoundID != 0 {
                AudioServicesPlaySystemSound(systemSoundID)
            }
            if vibrate {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
}


class SingleOperationQueue : OperationQueue {
    
    var delay: UInt32
    
    init(delay: UInt32 = 2) {
        self.delay = delay
        super.init()
        
        maxConcurrentOperationCount = 1
    }
    
    override func addOperation(_ block: @escaping () -> Void) {
        guard operationCount == 0 else { return }
        
        super.addOperation {
            guard self.operationCount == 1 else { return }
            block()
            sleep(self.delay)
        }
    }
    
}
