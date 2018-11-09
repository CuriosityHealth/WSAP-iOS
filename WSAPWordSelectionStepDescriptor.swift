//
//  WSAPWordSelectionStepDescriptor.swift
//  WSAP
//
//  Created by James Kizer on 11/9/18.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

open class WSAPWordSelectionStepDescriptor: WSAPStepDescriptor {

    public let crossTime: TimeInterval
    public let wordSelectionPrompt: String
    public let numberOfSentences: Int?
    
    public required init?(json: JSON) {
        
        guard let crossTime: TimeInterval = "cross_time" <~~ json,
            let wordSelectionPrompt: String = "wordSelectionPrompt" <~~ json else {
                return nil
        }
        
        self.crossTime = crossTime
        self.wordSelectionPrompt = wordSelectionPrompt
        self.numberOfSentences = "numberOfSentences" <~~ json
        super.init(json: json)
    }
    
}
