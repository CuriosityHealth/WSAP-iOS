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
    public let sentenceTime: TimeInterval
//    public let wordSelectionPrompt: String
    public let numberOfItems: Int?
    public let numberOfItemsKey: String?
    
    public required init?(json: JSON) {
        
        guard let crossTime: TimeInterval = "cross_time" <~~ json,
            let sentenceTime: TimeInterval = "sentence_time" <~~ json else {
                return nil
        }
        
        self.crossTime = crossTime
        self.sentenceTime = sentenceTime
        self.numberOfItems = "numberOfItems" <~~ json
        self.numberOfItemsKey = "numberOfItemsKey" <~~ json
        super.init(json: json)
    }
    
}
