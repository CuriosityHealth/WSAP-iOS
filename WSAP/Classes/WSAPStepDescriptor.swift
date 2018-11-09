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
    
    public required init?(json: JSON) {
        self.imageNameMap = "imageMap" <~~ json
        super.init(json: json)
    }
    
}
