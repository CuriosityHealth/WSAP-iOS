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
    
    public var trialResults: [WSAPTrialResult]?
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy: WSAPResult = super.copy(with: zone) as! WSAPResult
        copy.trialResults = trialResults
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
        if let results = self.trialResults {
            let jsonAnswers: [JSON] = results.compactMap { $0.toJSON() }
            return jsonAnswers as NSArray
        }
        return nil
    }
}
