//
//  WSAPCompleted.swift
//  WSAP
//
//  Created by James Kizer on 1/28/19.
//

import UIKit
import ResearchSuiteResultsProcessor
import ResearchKit
import Gloss
import ResearchSuiteApplicationFramework

open class WSAPCompleted: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    static open let kType = "WSAPCompleted"
    
    private static let supportedTypes = [
        kType
    ]
    
    open static func supportsType(type: String) -> Bool {
        return supportedTypes.contains(type)
    }
    
    public static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let stepResult = parameters["result"] as? ORKStepResult,
            let wsapResult = stepResult.firstResult as? WSAPResult else {
                return nil
        }
        
        return WSAPCompleted(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            result: wsapResult
        )
        
    }
    
    let result: WSAPResult
    public init(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: WSAPResult
        ) {
        
        self.result = result
        super.init(
            type: WSAPSummaryStatistics.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
    
}

extension WSAPCompleted {
    open override func evaluate() -> AnyObject? {
        return self.result.completed as AnyObject
    }
}