//
//  WSAPReverseOrderTrial.swift
//  WSAP
//
//  Created by James Kizer on 11/9/18.
//

import UIKit

open class WSAPReverseOrderTrial: WSAPTrial {
    
    public let word: String
    public let sentence: String
    public let crossTime: TimeInterval
    public let wordTime: TimeInterval
    public let sentenceButtonText: String
    public let choicePrompt: String
    public let affirmativeButtonText: String?
    public let negativeButtonText: String?
    public let correctResponse: WSAPStandardTrialResponseType
    
    public let feedback: WSAPTrialFeedback?
    
    public init(
        trialId: String,
        word: String,
        sentence: String,
        crossTime: TimeInterval,
        wordTime: TimeInterval,
        sentenceButtonText: String,
        choicePrompt: String,
        affirmativeButtonText: String?,
        negativeButtonText: String?,
        correctResponse: WSAPStandardTrialResponseType,
        feedback: WSAPTrialFeedback?
        ) {
        
        self.word = word
        self.sentence = sentence
        self.sentenceButtonText = sentenceButtonText
        self.crossTime = crossTime
        self.wordTime = wordTime
        self.choicePrompt = choicePrompt
        self.affirmativeButtonText = affirmativeButtonText
        self.negativeButtonText = negativeButtonText
        self.correctResponse = correctResponse
        self.feedback = feedback
        
        super.init(trialId: trialId)
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override open func trialDelegate() -> WSAPTrialDelegate {
        return WSAPReverseOrderTrialDelegate.shared
    }

}
