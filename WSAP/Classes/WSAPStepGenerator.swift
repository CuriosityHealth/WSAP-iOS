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
        
        let imageMapPairs: [(String, UIImage)] = stepDescriptor.imageNameMap?.compactMap({ (pair) -> (String, UIImage)? in
            if let image = UIImage(named: pair.value) {
                return (pair.key, image)
            }
            else {
                return nil
            }
        }) ?? []
        
        let imageMap: [String: UIImage] = Dictionary.init(uniqueKeysWithValues: imageMapPairs)
        
        let step = WSAPStep(
            identifier: stepDescriptor.identifier,
            title: stepDescriptor.title,
            text: stepDescriptor.text,
            trials: trials,
            imageMap: imageMap
//            crossImage: crossImage,
//            correctImage: correctImage,
//            incorrectImage: incorrectImage
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
