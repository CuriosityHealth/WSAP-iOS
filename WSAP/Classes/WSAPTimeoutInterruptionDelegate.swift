//
//  WSAPTimeoutInterruptionDelegate.swift
//  WSAP
//
//  Created by James Kizer on 1/29/19.
//

import UIKit
import Gloss

public protocol WSAPTimeoutInterruptionDelegate {
    func shouldEnd(startTime: Date, interruptionCount: Int) -> Bool
    func interruptionAlertTitleAndMessage(startTime: Date, interruptionCount: Int) -> (String, String)
}

public struct WSAPDefaultTimeoutInterruptionDelegate: WSAPTimeoutInterruptionDelegate, JSONDecodable {
    
    public init?(json: JSON) {
        guard let alertTitle: String = "alertTitle" <~~ json,
            let alertMessage: String = "alertMessage" <~~ json else {
                return nil
        }
        
        self.maximumDuration = {
            //in minutes
            guard let maximumDuration: Int = "maximumDurationInMinutes" <~~ json else {
                return TimeInterval.infinity
            }
            
            return Double(maximumDuration) * 60.0
        }()

        self.maximumInterruptions = "maximumInterruptions" <~~ json ?? Int.max
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
    }
    
    let maximumDuration: TimeInterval
    let maximumInterruptions: Int
    let alertTitle: String
    let alertMessage: String
    
    public func shouldEnd(startTime: Date, interruptionCount: Int) -> Bool {
        
        let duration = Date().timeIntervalSince(startTime)
        return duration > self.maximumDuration || interruptionCount > self.maximumInterruptions
    }
    
    public func interruptionAlertTitleAndMessage(startTime: Date, interruptionCount: Int) -> (String, String) {
        return (alertTitle, alertMessage)
    }
    
}
