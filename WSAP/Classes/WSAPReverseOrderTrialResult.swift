//
//  WSAPReverseOrderTrialResult.swift
//  WSAP
//
//  Created by James Kizer on 11/9/18.
//

import UIKit

open class WSAPReverseOrderTrialResult: WSAPTrialResult {
    
    override open func abstractEncode(encodeClosure: (String, Any) -> ()) {
        super.abstractEncode(encodeClosure: encodeClosure)
        encodeClosure("sentence_response_time", self.sentenceResponseTime)
        encodeClosure("choice_response_time", self.choiceResponseTime)
        encodeClosure("actual_response", self.response.rawValue)
        encodeClosure("correct_response", self.standardTrial.correctResponse.rawValue)
    }
    
    open override var isCorrect: Bool {
        return self.standardTrial.correctResponse == self.response
    }
    
    open override var measuredResponseTime: TimeInterval {
        return self.choiceResponseTime
    }
    
    public let sentenceResponseTime: TimeInterval
    public let choiceResponseTime: TimeInterval
    public let response: WSAPStandardTrialResponseType
    public var standardTrial: WSAPReverseOrderTrial {
        return self.trial as! WSAPReverseOrderTrial
    }
    
    public init(
        index: Int,
        trial: WSAPReverseOrderTrial,
        sentenceResponseTime: TimeInterval,
        choiceResponseTime: TimeInterval,
        response: WSAPStandardTrialResponseType
        ) {
        self.sentenceResponseTime = sentenceResponseTime
        self.choiceResponseTime = choiceResponseTime
        self.response = response
        super.init(index: index, trial: trial)
    }
    
}
