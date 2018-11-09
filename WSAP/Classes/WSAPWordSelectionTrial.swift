//
//  WSAPWordSelectionTrial.swift
//  WSAP
//
//  Created by James Kizer on 11/8/18.
//

import UIKit

public enum WSAPWordSelectionTrialResponseType: String, Codable {
    case left = "left"
    case right = "right"
}

open class WSAPWordSelectionTrial: WSAPTrial {
    public let leftWord: String
    public let rightWord: String
    public let wordSelectionPrompt: String
    public let sentence: String
    public let sentenceButtonText: String
    public let crossTime: TimeInterval
    public let correctResponse: WSAPWordSelectionTrialResponseType
    
    public let feedback: WSAPTrialFeedback?
    
    public init(
        trialId: String,
        leftWord: String,
        rightWord: String,
        wordSelectionPrompt: String,
        sentence: String,
        sentenceButtonText: String,
        crossTime: TimeInterval,
        correctResponse: WSAPWordSelectionTrialResponseType,
        feedback: WSAPTrialFeedback?
        ) {
        
        self.leftWord = leftWord
        self.rightWord = rightWord
        self.wordSelectionPrompt = wordSelectionPrompt
        self.sentence = sentence
        self.sentenceButtonText = sentenceButtonText
        self.crossTime = crossTime
        self.correctResponse = correctResponse
        self.feedback = feedback
        
        super.init(trialId: trialId)
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override open func trialDelegate() -> WSAPTrialDelegate {
        return WSAPWordSelectionTrialDelegate.shared
    }
    
}
