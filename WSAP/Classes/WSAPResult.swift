//
//  WSAPResult.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss

open class WSAPResult: ORKResult {
    
    public var interruptionCount: Int?
    public var trialResults: [WSAPTrialResult]?
    public var completed: Bool = false
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy: WSAPResult = super.copy(with: zone) as! WSAPResult
        copy.trialResults = self.trialResults
        copy.interruptionCount = self.interruptionCount
        copy.completed = self.completed
        return copy
    }

    override open var description: String {
        
        guard let trialResults = trialResults else {
            return "\(self.identifier): No Trial Results"
        }
        
        return "\(self.identifier): \(trialResults.count) Trial Results"
    }
}

extension WSAPResult: RSRPDefaultValueTransformer {
    public var defaultValue: AnyObject? {
        if let results = self.trialResults,
            let interruptionCount = self.interruptionCount {
            
            guard let timeIntervalJSON: JSON = jsonify([
                Gloss.Encoder.encode(dateISO8601ForKey: "start_date_time")(self.startDate),
                Gloss.Encoder.encode(dateISO8601ForKey: "end_date_time")(self.endDate),
                ]) else {
                    return nil
            }
            
            return jsonify([
                "results" ~~> results,
                "effective_time_frame" ~~> ("time_interval" ~~> timeIntervalJSON),
                "interruptions" ~~> interruptionCount,
                "compeleted" ~~> self.completed
                ]) as NSDictionary?
            
        }
        return nil
    }
}
