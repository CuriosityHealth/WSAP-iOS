//
//  WSAPTrialResult.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//

import UIKit
import Gloss

public struct WSAPTrialResult: Gloss.JSONEncodable, Swift.Encodable {
    
    private typealias EncodeClosure = (String, Any)->()
    
    private func abstractEncode(encodeClosure: EncodeClosure) {
        encodeClosure("identifier", self.trial.trialId)
        encodeClosure("index", self.index)
        encodeClosure("response_time", self.responseTime)
        encodeClosure("actual_response", self.response.rawValue)
        encodeClosure("correct_response", self.trial.correctResponse.rawValue)
    }
    
    public func toJSON() -> JSON? {
        
        var dict: [String: Any] = [:]
        let encodeClosure: EncodeClosure = { (key, value) in
            dict[key] = value
        }
        
        self.abstractEncode(encodeClosure: encodeClosure)
        
        return dict
        
    }
    
    public func encode(with aCoder: NSCoder)
    {
        let encodeClosure: EncodeClosure = { (key, value) in
            aCoder.encode(value, forKey: key)
        }
        
        self.abstractEncode(encodeClosure: encodeClosure)
    }
    
    public let trial: WSAPTrial
    public let index: Int
    public let responseTime: TimeInterval
    public let response: WSAPTrialResponseType
    
    
}
