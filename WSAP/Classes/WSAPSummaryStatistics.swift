//
//  WSAPSummaryStatistics.swift
//  iChange
//
//  Created by James Kizer on 6/14/18.
//  Copyright © 2018 James Kizer. All rights reserved.
//

import UIKit
import ResearchSuiteResultsProcessor
import ResearchKit
import Gloss
import LS2SDK
import ResearchSuiteApplicationFramework

public struct WSAPSummaryStatisticsStruct: Glossy {
   
    public init(
        totalResponses: Int,
         totalCorrect: Int,
         ratioCorrect: Double,
         averageResponseTime: TimeInterval
        ) {
        self.totalResponses = totalResponses
        self.totalCorrect = totalCorrect
        self.ratioCorrect = ratioCorrect
        self.averageResponseTime = averageResponseTime
    }
    public init?(json: JSON) {
        
        guard let totalResponses: Int = "totalResponses" <~~ json,
            let totalCorrect: Int = "totalCorrect" <~~ json,
            let ratioCorrect: Double = "ratioCorrect" <~~ json,
            let averageResponseTime: TimeInterval = "averageResponseTime" <~~ json else {
                return nil
        }
        self.totalResponses = totalResponses
        self.totalCorrect = totalCorrect
        self.ratioCorrect = ratioCorrect
        self.averageResponseTime = averageResponseTime
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "totalResponses" ~~> self.totalResponses,
            "totalCorrect" ~~> self.totalCorrect,
            "ratioCorrect" ~~> self.ratioCorrect,
            "averageResponseTime" ~~> self.averageResponseTime
            ])
    }
    
    public let totalResponses: Int
    public let totalCorrect: Int
    public let ratioCorrect: Double
    public let averageResponseTime: TimeInterval
}

open class WSAPSummaryStatistics: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    static public let kType = "WSAPSummaryStatistics"
    
    private static let supportedTypes = [
        kType
    ]
    
    public static func supportsType(type: String) -> Bool {
        return supportedTypes.contains(type)
    }
    
    public static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let stepResult = parameters["result"] as? ORKStepResult,
            let wsapResult = stepResult.firstResult as? WSAPResult,
            let trialResults = wsapResult.trialResults else {
                return nil
        }
        
        let correctAnswers = trialResults.filter { $0.isCorrect }
        let ratioCorrect: Double = Double(correctAnswers.count) / Double(trialResults.count)
        
        let totalResponseTime: TimeInterval = trialResults.map { $0.measuredResponseTime }.reduce(0.0, +)
        let averageResponseTime: TimeInterval = totalResponseTime / TimeInterval(trialResults.count)
        
        let summaryStats = WSAPSummaryStatisticsStruct.init(
            totalResponses: trialResults.count,
            totalCorrect: correctAnswers.count,
            ratioCorrect: ratioCorrect,
            averageResponseTime: averageResponseTime
        )
        
        let schema: LS2Schema? = "schema" <~~ parameters
        
        return WSAPSummaryStatistics(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            summaryStats: summaryStats,
            schema: schema
        )
        
    }
    
    public let summaryStats: WSAPSummaryStatisticsStruct
    
    public let schema: LS2Schema?
    
    public init(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        summaryStats: WSAPSummaryStatisticsStruct,
        schema: LS2Schema?
        ) {
        
        self.summaryStats = summaryStats
        self.schema = schema
        super.init(
            type: WSAPSummaryStatistics.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
    
}

extension WSAPSummaryStatistics {
    open override func evaluate() -> AnyObject? {
        if self.schema == nil {
            return self.summaryStats.toJSON() as AnyObject
        }
        else {
            return self
        }
    }
}

extension WSAPSummaryStatistics: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        guard let schema = self.schema,
            let body: JSON = self.summaryStats.toJSON() else {
            return nil
        }
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: schema, acquisitionProvenance: acquisitionSource, metadata: nil)
        return builder.createDatapoint(header: header, body: body)
        
    }
    
}
