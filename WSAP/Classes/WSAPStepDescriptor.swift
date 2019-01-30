//
//  WSAPStepDescriptor.swift
//  iChange
//
//  Created by James Kizer on 6/15/18.
//  Copyright © 2018 James Kizer. All rights reserved.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

open class WSAPStepDescriptor: RSTBStepDescriptor {
    
    public let imageNameMap: [String: String]?
    public let timeoutInterruptionJSON: JSON?
    
    public required init?(json: JSON) {
        self.imageNameMap = "imageMap" <~~ json
        self.timeoutInterruptionJSON = "timeoutInterruption" <~~ json
        super.init(json: json)
    }
    
}
