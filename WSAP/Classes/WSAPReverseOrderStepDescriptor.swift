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
    
    public let crossTime: TimeInterval?
    public let crossTimeKey: String?
    public let wordTime: TimeInterval?
    public let wordTimeKey: String?
    public let relatedIdentifierSuffix: String
    public let unrelatedIdentifierSuffix: String
    public let choicePrompt: String
    public let affirmativeButtonText: String
    public let negativeButtonText: String
    public let numberOfItems: Int?
    public let numberOfItemsKey: String?
    
    public required init?(json: JSON) {
        
        guard let relatedIdentifierSuffix: String = "related_identifier_suffix" <~~ json,
            let unrelatedIdentifierSuffix: String = "unrelated_identifier_suffix" <~~ json,
            let choicePrompt: String = "choice_prompt" <~~ json,
            let affirmativeButtonText: String = "affirmative_button_text" <~~ json,
            let negativeButtonText: String = "negative_button_text" <~~ json else {
                return nil
        }
        
        self.crossTime = "cross_time" <~~ json
        self.crossTimeKey = "cross_time" <~~ json
        self.wordTime = "word_time" <~~ json
        self.wordTimeKey = "word_time" <~~ json
        self.relatedIdentifierSuffix = relatedIdentifierSuffix
        self.unrelatedIdentifierSuffix = unrelatedIdentifierSuffix
        self.choicePrompt = choicePrompt
        self.affirmativeButtonText = affirmativeButtonText
        self.negativeButtonText = negativeButtonText
        self.numberOfItems = "numberOfItems" <~~ json
        self.numberOfItemsKey = "numberOfItemsKey" <~~ json
        super.init(json: json)
    }
    
}
