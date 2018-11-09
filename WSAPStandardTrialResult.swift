//
//  WSAPStandardExerciseTrialResult.swift
//  WSAP
//
//  Created by James Kizer on 11/8/18.
//

import UIKit

open class WSAPStandardTrialResult: WSAPTrialResult {

    override open func abstractEncode(encodeClosure: (String, Any) -> ()) {
        super.abstractEncode(encodeClosure: encodeClosure)
        encodeClosure("response_time", self.responseTime)
        encodeClosure("actual_response", self.response.rawValue)
        encodeClosure("correct_response", self.standardTrial.correctResponse.rawValue)
    }
    
    open override var isCorrect: Bool {
        return self.standardTrial.correctResponse == self.response
    }
    
    open override var measuredResponseTime: TimeInterval {
        return self.responseTime
    }

    public let responseTime: TimeInterval
    public let response: WSAPStandardTrialResponseType
    public var standardTrial: WSAPStandardTrial {
        return self.trial as! WSAPStandardTrial
    }
    
    public init(
        index: Int,
        trial: WSAPStandardTrial,
        responseTime: TimeInterval,
        response: WSAPStandardTrialResponseType
        ) {
        self.responseTime = responseTime
        self.response = response
        super.init(index: index, trial: trial)
    }

}
