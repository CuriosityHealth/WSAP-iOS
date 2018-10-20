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
    open let crossImage: UIImage?
    open let correctImage: UIImage?
    open let incorrectImage: UIImage?
    
    public init(
        identifier: String,
        title: String?,
        text: String?,
        trials: [WSAPTrial],
        crossImage: UIImage?,
        correctImage: UIImage?,
        incorrectImage: UIImage?
        ) {
        
        self.trials = trials
        self.crossImage = crossImage
        self.correctImage = correctImage
        self.incorrectImage = incorrectImage
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
