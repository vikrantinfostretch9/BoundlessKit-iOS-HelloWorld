//
//  DopamineKit.swift
//  Dopamine functionality for swift
//
//  Created by Vince Enachescu on 4/7/16.
//  Copyright © 2016 Dopamine Labs. All rights reserved.
//

import Foundation
import UIKit
import SQLite

@objc
public class DopamineKit : NSObject {
    
    public static let sharedInstance: DopamineKit = DopamineKit()
    
    private let dataStore:SQLiteDataStore = SQLiteDataStore.sharedInstance
    private let cartridgeSyncer = CartridgeSyncer.sharedInstance
    private let trackSyncer = TrackSyncer.sharedInstance
    private let reportSyncer = ReportSyncer.sharedInstance
    
    private override init() {
        dataStore.createTables()
    }
        
    /// This function sends an asynchronous tracking call for the specified actionID
    ///
    /// - parameters:
    ///     - actionID: Descriptive name of the action.
    ///     - metaData?: Action details i.e. calories or streak_count. 
    ///                  Must be JSON formattable (Number, String, Bool, Array, Object).
    ///                  Defaults to `nil`.
    ///
    public static func track(actionID: String, metaData: [String: AnyObject]? = nil) {
        let si = sharedInstance

        // store the action to be synced
        let action = DopeAction(actionID: actionID, metaData:metaData)
        si.trackSyncer.store(action)
        SyncCoordinator.sync()
    }

    /// This function sends an asynchronous reinforcement call for the specified actionID
    ///
    /// - parameters:
    ///     - actionID: Descriptive name of the action.
    ///     - metaData?: Action details i.e. calories or streak_count.
    ///                  Must be JSON formattable (Number, String, Bool, Array, Object).
    ///                  Defaults to `nil`.
    ///     - completion: A closure with the reinforcement response passed in as a `String`.
    ///
    public static func reinforce(actionID: String, metaData: [String: AnyObject]? = nil, completion: (String) -> ()) {
        let si = sharedInstance
        let reinforcementDecision = si.cartridgeSyncer.unload(actionID)
        
        dispatch_async(dispatch_get_main_queue(), {
            completion(reinforcementDecision)
        })
        
        // store the action to be synced
        let action = DopeAction(actionID: actionID, reinforcementDecision: reinforcementDecision, metaData: metaData)
        si.reportSyncer.store(action)
        SyncCoordinator.sync()
    }
    
    
    /// This function sends debug messages if "-D DEBUG" flag is added in 'Build Settings' > 'Swift Compiler - Custom Flags'
    ///
    /// - parameters:
    ///     - message: The debug message.
    ///     - filename?: Used to get filename of bug. Do not use this parameter. Defaults to #file.
    ///     - function?: Used to get function name of bug. Do not use this parameter. Defaults to #function.
    ///     - line?: Used to get the line of bug. Do not use this parameter. Defaults to #line.
    ///
    internal static func DebugLog(message: String,  filePath: String = #file, function: String =  #function, line: Int = #line) {
        #if DEBUG
            var functionSignature:String = function
            if let parameterNames = functionSignature.rangeOfString("\\((.*?)\\)", options: .RegularExpressionSearch){
                functionSignature.replaceRange(parameterNames, with: "()")
            }
            let fileName = NSString(string: filePath).lastPathComponent.componentsSeparatedByString(".")[0]
            NSLog("[\(fileName):\(line):\(functionSignature)] - \(message)")
        #endif
    }

}