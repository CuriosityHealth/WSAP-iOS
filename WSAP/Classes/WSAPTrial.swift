//
//  WSAPTrial.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//
import UIKit

public enum WSAPConfirmationType: String, Codable {
    case timed = "timed"
    case interaction = "interaction"
}

public enum WSAPTrialResponseType: String, Codable {
    case affirmative = "affirmative"
    case negative = "negative"
}

public struct WSAPTrial: Codable {
    public let trialId: String
    public let word: String
    public let sentence: String
    public let crossTime: TimeInterval
    public let wordTime: TimeInterval
    public let affirmativeButtonText: String?
    public let negativeButtonText: String?
    public let confirmation: WSAPConfirmationType?
    public let confirmationTime: TimeInterval?
    public let confirmationText: String?
    public let correctFeedback: [String]?
    public let incorrectFeedback: [String]?
    public let correctResponse: WSAPTrialResponseType
    
    public init(
        trialId: String,
        word: String,
        sentence: String,
        crossTime: TimeInterval,
        wordTime: TimeInterval,
        affirmativeButtonText: String?,
        negativeButtonText: String?,
        confirmation: WSAPConfirmationType?,
        confirmationTime: TimeInterval?,
        confirmationText: String?,
        correctFeedback: [String]?,
        incorrectFeedback: [String]?,
        correctResponse: WSAPTrialResponseType
        ) {
        self.trialId = trialId
        self.word = word
        self.sentence = sentence
        self.wordTime = wordTime
        self.crossTime = crossTime
        self.affirmativeButtonText = affirmativeButtonText
        self.negativeButtonText = negativeButtonText
        self.confirmation = confirmation
        self.confirmationTime = confirmationTime
        self.confirmationText = confirmationText
        self.correctFeedback = correctFeedback
        self.incorrectFeedback = incorrectFeedback
        self.correctResponse = correctResponse
    }
    
}
