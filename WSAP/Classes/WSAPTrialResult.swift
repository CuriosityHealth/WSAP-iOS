//
//  WSAPTrialResult.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//

import UIKit
import Gloss

open class WSAPTrialResult: NSObject, Gloss.JSONEncodable, Swift.Encodable {
    
    public typealias EncodeClosure = (String, Any)->()
    
    open func abstractEncode(encodeClosure: EncodeClosure) {
        
//        assertionFailure("Not Implemented")
        encodeClosure("identifier", self.trial.trialId)
        encodeClosure("index", self.index)
        
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
    
    open var isCorrect: Bool {
        assertionFailure("Not Implemented")
        return false
    }
    
    open var measuredResponseTime: TimeInterval {
        assertionFailure("Not Implemented")
        return Double.infinity
    }
    
    public let trial: WSAPTrial
    public let index: Int
    
    public init(
        index: Int,
        trial: WSAPTrial
        ) {
        self.index = index
        self.trial = trial
        super.init()
    }
}
