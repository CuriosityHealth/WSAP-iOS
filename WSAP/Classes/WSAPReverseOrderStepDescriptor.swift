//
//  WSAPReverseOrderStepDescriptor.swift
//  WSAP
//
//  Created by James Kizer on 11/9/18.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

open class WSAPReverseOrderStepDescriptor: WSAPStepDescriptor {
    
    public let crossTime: TimeInterval
    public let wordTime: TimeInterval
    public let relatedIdentifierSuffix: String
    public let unrelatedIdentifierSuffix: String
    public let choicePrompt: String
    public let affirmativeButtonText: String
    public let negativeButtonText: String
    public let numberOfSentences: Int?
    
    public required init?(json: JSON) {
        
        guard let crossTime: TimeInterval = "cross_time" <~~ json,
            let wordTime: TimeInterval = "word_time" <~~ json,
            let relatedIdentifierSuffix: String = "related_identifier_suffix" <~~ json,
            let unrelatedIdentifierSuffix: String = "unrelated_identifier_suffix" <~~ json,
            let choicePrompt: String = "choice_prompt" <~~ json,
            let affirmativeButtonText: String = "affirmative_button_text" <~~ json,
            let negativeButtonText: String = "negative_button_text" <~~ json else {
                return nil
        }
        
        self.crossTime = crossTime
        self.wordTime = wordTime
        self.relatedIdentifierSuffix = relatedIdentifierSuffix
        self.unrelatedIdentifierSuffix = unrelatedIdentifierSuffix
        self.choicePrompt = choicePrompt
        self.affirmativeButtonText = affirmativeButtonText
        self.negativeButtonText = negativeButtonText
        self.numberOfSentences = "numberOfSentences" <~~ json
        super.init(json: json)
    }
    
}
