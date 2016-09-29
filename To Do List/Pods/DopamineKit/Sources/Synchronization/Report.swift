//
//  Report.swift
//  Pods
//
//  Created by Akash Desai on 8/1/16.
//
//

import Foundation



@objc
class Report : NSObject, NSCoding {
    
    static let sharedInstance = Report()
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let defaultsKey = "DopamineReport"
    
    private let sizeKey = "size"
    private let sizeToSyncKey = "sizeToSync"
    private let timerStartsAtKey = "timerStartsAt"
    private let timerExpiresInKey = "timerExpiresIn"

    
    private var sizeToSync: Int
    private var timerStartsAt: Int64
    private var timerExpiresIn: Int64
    
    private var syncInProgress = false
    
    /// Loads the report from NSUserDefaults or creates a new one and saves it to NSUserDefaults
    ///
    private override init() {
        if let savedReportData = defaults.objectForKey(defaultsKey) as? NSData,
            let savedReport = NSKeyedUnarchiver.unarchiveObjectWithData(savedReportData) as? Report {
            self.sizeToSync = savedReport.sizeToSync
            self.timerStartsAt = savedReport.timerStartsAt
            self.timerExpiresIn = savedReport.timerExpiresIn
            super.init()
        } else {
            self.sizeToSync = 15
            self.timerStartsAt = Int64(1000*NSDate().timeIntervalSince1970)
            self.timerExpiresIn = 172800000
            super.init()
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: defaultsKey)
        }
    }
    
    /// Decodes a saved report from NSUserDefaults
    ///
    required init(coder aDecoder: NSCoder) {
        self.sizeToSync = aDecoder.decodeIntegerForKey(sizeToSyncKey)
        self.timerStartsAt = aDecoder.decodeInt64ForKey(timerStartsAtKey)
        self.timerExpiresIn = aDecoder.decodeInt64ForKey(timerExpiresInKey)
        DopamineKit.DebugLog("Decoded report with sizeToSync:\(sizeToSync) timerStartsAt:\(timerStartsAt) timerExpiresIn:\(timerExpiresIn)")
    }
    
    /// Encodes a report and saves it to NSUserDefaults
    ///
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(sizeToSync, forKey: sizeToSyncKey)
        aCoder.encodeInt64(timerStartsAt, forKey: timerStartsAtKey)
        aCoder.encodeInt64(timerExpiresIn, forKey: timerExpiresInKey)
        DopamineKit.DebugLog("Encoded report with sizeToSync:\(sizeToSync) timerStartsAt:\(timerStartsAt) timerExpiresIn:\(timerExpiresIn)")
    }
    
    /// Returns a JSON compatible object of the sync triggers
    ///
    func decodeJSONForTriggers() -> [String: AnyObject]{
        return [
            sizeKey : SQLReportedActionDataHelper.count(),
            sizeToSyncKey : sizeToSync,
            timerStartsAtKey : NSNumber(longLong: timerStartsAt),
            timerExpiresInKey : NSNumber(longLong: timerExpiresIn)
        ]
    }
    
    /// Updates the sync triggers
    ///
    /// - parameters:
    ///     - sizeToSync: The number of reported actions to trigger a sync. Defaults to previous sizeToSync.
    ///     - timerStartsAt: The start time for a sync timer. Defaults to the current time.
    ///     - timerExpiresIn: The timer length, in ms, for a sync timer. Defaults to previous timerExpiresIn.
    ///
    func updateTriggers(sizeToSync: Int?=nil, timerStartsAt: Int64?=Int64( 1000*NSDate().timeIntervalSince1970 ), timerExpiresIn: Int64?=nil) {
        if let sizeToSync = sizeToSync {
            self.sizeToSync = sizeToSync
        }
        if let timerStartsAt = timerStartsAt {
            self.timerStartsAt = timerStartsAt
        }
        if let timerExpiresIn = timerExpiresIn {
            self.timerExpiresIn = timerExpiresIn
        }
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: defaultsKey)
    }
    
    /// Clears the saved report sync triggers from NSUserDefaults
    ///
    func removeTriggers() {
        self.sizeToSync = 15
        self.timerStartsAt = 0
        self.timerExpiresIn = 172800000
        defaults.removeObjectForKey(defaultsKey)
    }
    
    /// Check whether the report has been triggered for a sync
    ///
    /// - returns: Whether a sync has been triggered.
    ///
    func isTriggered() -> Bool {
        return timerDidExpire() || isSizeToSync()
    }
    
    /// Checks if the sync timer has expired
    ///
    /// - returns: Whether the timer has expired.
    ///
    private func timerDidExpire() -> Bool {
        let currentTime = Int64( 1000*NSDate().timeIntervalSince1970 )
        let isExpired = currentTime >= (timerStartsAt + timerExpiresIn)
        DopamineKit.DebugLog("Report timer expires in \(timerStartsAt + timerExpiresIn - currentTime)ms so the timer \(isExpired ? "will" : "won't") trigger a sync...")
        return isExpired
    }
    
    /// Checks if the report is at the size to sync
    ///
    /// - returns: Whether there are enough reported actions to trigger a sync.
    ///
    private func isSizeToSync() -> Bool {
        let count = SQLReportedActionDataHelper.count()
        let isSize = count >= sizeToSync
        DopamineKit.DebugLog("Report has \(count)/\(sizeToSync) actions so the size \(isSize ? "will" : "won't") trigger a sync...")
        return isSize
    }
    
    /// Stores a reported action to be synced over the DopamineAPI at a later time
    ///
    /// - parameters:
    ///     - action: The action to be stored.
    ///
    func add(action: DopeAction) {
        let recordedAction = SQLReportedAction(
            index:0,
            actionID: action.actionID,
            reinforcementDecision: action.reinforcementDecision!,
            metaData: action.metaData,
            utc: action.utc,
            timezoneOffset: action.timezoneOffset
        )
        guard let _ = SQLReportedActionDataHelper.insert(recordedAction) else {
                // if it couldnt be saved, send it right away
                DopamineKit.DebugLog("SQLiteDataStore error, sending single action report")
                DopamineAPI.report([recordedAction], completion: { response in
                    
                })
                return
        }
    }
    
    /// Sends reinforced actions over the DopamineAPI
    ///
    /// - parameters:
    ///     - completion(Int): Takes the status code returned from DopamineAPI, or 0 if there were no actions to sync.
    ///
    func sync(completion: (statusCode: Int) -> () = { _ in }) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            guard !self.syncInProgress else {
                DopamineKit.DebugLog("Report sync already happening")
                completion(statusCode: 0)
                return
            }
            self.syncInProgress = true
            
            let sqlActions = SQLReportedActionDataHelper.findAll()
            
            if sqlActions.count == 0 {
                defer { self.syncInProgress = false }
                DopamineKit.DebugLog("No reported actions to sync.")
                completion(statusCode: 0)
                self.updateTriggers()
            } else {
                DopamineKit.DebugLog("Sending \(sqlActions.count) reported actions...")
                DopamineAPI.report(sqlActions, completion: { response in
                    defer { self.syncInProgress = false }
                    if let responseStatusCode = response["status"] as? Int {
                        completion(statusCode: responseStatusCode)
                        if responseStatusCode == 200 {
                            for action in sqlActions {
                                SQLReportedActionDataHelper.delete(action);
                            }
                            self.updateTriggers()
                        }
                    } else {
                        completion(statusCode: 404)
                    }
                })
            }
            
        }
    }
    
}
