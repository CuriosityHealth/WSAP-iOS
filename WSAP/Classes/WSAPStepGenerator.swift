//
//  WSAPStepGenerator.swift
//  WSAP
//
//  Created by James Kizer on 10/19/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchKit

open class WSAPStepGenerator: RSTBBaseStepGenerator {
   
    public init() {}
    
    open var supportedTypes: [String]! {
        return []
    }
    
    
    open func generateTrials(jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [WSAPTrial]? {
        assertionFailure("Not Implemented!!")
        return nil
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = WSAPStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        guard let trials = self.generateTrials(jsonObject: jsonObject, helper: helper) else {
            return nil
        }
        
        let crossImage: UIImage? = {
            if let imageName = stepDescriptor.crossImageName {
                return UIImage(named: imageName)
            }
            else {
                return nil
            }
        }()
        
        let correctImage: UIImage? = {
            if let imageName = stepDescriptor.correctImageName {
                return UIImage(named: imageName)
            }
            else {
                return nil
            }
        }()
        
        let incorrectImage: UIImage? = {
            if let imageName = stepDescriptor.incorrectImageName {
                return UIImage(named: imageName)
            }
            else {
                return nil
            }
        }()
        
        let step = WSAPStep(
            identifier: stepDescriptor.identifier,
            title: stepDescriptor.title,
            text: stepDescriptor.text,
            trials: trials,
            crossImage: crossImage,
            correctImage: correctImage,
            incorrectImage: incorrectImage
        )
        
        step.isOptional = stepDescriptor.optional
        
        return step
        
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
