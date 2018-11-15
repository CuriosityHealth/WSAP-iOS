//
//  WSAPWordSelectionTrialResult.swift
//  WSAP
//
//  Created by James Kizer on 11/8/18.
//

import UIKit

open class WSAPWordSelectionTrialResult: WSAPTrialResult {
    
    override open func abstractEncode(encodeClosure: (String, Any) -> ()) {
        super.abstractEncode(encodeClosure: encodeClosure)
//        encodeClosure("sentence_response_time", self.sentenceResponseTime)
        encodeClosure("words_response_time", self.wordsResponseTime)
        encodeClosure("left_word", self.wordSelectionTrial.leftWord)
        encodeClosure("right_word", self.wordSelectionTrial.rightWord)
        encodeClosure("actual_response", self.response.rawValue)
        encodeClosure("correct_response", self.wordSelectionTrial.correctResponse.rawValue)
    }
    
    open override var isCorrect: Bool {
        return self.wordSelectionTrial.correctResponse == self.response
    }
    
    open override var measuredResponseTime: TimeInterval {
        return self.wordsResponseTime
    }
    
//    public let sentenceResponseTime: TimeInterval
    public let wordsResponseTime: TimeInterval
    public let response: WSAPWordSelectionTrialResponseType
    public var wordSelectionTrial: WSAPWordSelectionTrial {
        return self.trial as! WSAPWordSelectionTrial
    }
    
    public init(
        index: Int,
        trial: WSAPWordSelectionTrial,
//        sentenceResponseTime: TimeInterval,
        wordsResponseTime: TimeInterval,
        response: WSAPWordSelectionTrialResponseType
        ) {
//        self.sentenceResponseTime = sentenceResponseTime
        self.wordsResponseTime = wordsResponseTime
        self.response = response
        super.init(index: index, trial: trial)
    }
    
}
