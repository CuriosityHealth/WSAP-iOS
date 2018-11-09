//
//  WSAPStep.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteExtensions

open class WSAPStep: RSStep {
    
    open let trials: [WSAPTrial]
    open let imageMap: [String: UIImage]
    
    public init(
        identifier: String,
        title: String?,
        text: String?,
        trials: [WSAPTrial],
        imageMap: [String: UIImage]
        ) {
        
        self.trials = trials
        self.imageMap = imageMap
        super.init(identifier: identifier)
        self.title = title
        self.text = text
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func stepViewControllerClass() -> AnyClass {
        return WSAPStepViewController.self
    }

}
