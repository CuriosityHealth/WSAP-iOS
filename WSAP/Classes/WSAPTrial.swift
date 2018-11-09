//
//  WSAPTrial.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//
import UIKit

public enum WSAPTrialComponentPresentationType {
    case nothing
    case image(UIImage)
    case imageWithText(UIImage, String)
    case text(String)
}

public enum WSAPTrialComponentContinuationType {
    case nothing
    case timed(TimeInterval)
    //(identifier,
    case buttons([(String, String)])
}

public enum WSAPTrialComponentOutcomeType {
    case timeExpired(duration: TimeInterval)
    case buttonPressed(identifier: String, duration: TimeInterval)
}

public struct WSAPTrialComponent {
    public let identifier: String
    public let presentation: WSAPTrialComponentPresentationType
    public let continuation: WSAPTrialComponentContinuationType
}

public struct WSAPTrialComponentResult {
    public let trialComponent: WSAPTrialComponent
    public let trialComponentOutcome: WSAPTrialComponentOutcomeType
}

public protocol WSAPTrialDelegate {
    func trialComponent(trial: WSAPTrial, lastTrialComponent: WSAPTrialComponent?, trialComponentResults: [WSAPTrialComponentResult]?, viewController: WSAPStepViewController) -> WSAPTrialComponent?
    func trialResult(trial: WSAPTrial, trialIndex: Int, trialComponentResults: [WSAPTrialComponentResult]) -> WSAPTrialResult?
}

open class WSAPTrial: Codable {
    
    open func trialDelegate() -> WSAPTrialDelegate {
        fatalError("Not Implemented")
    }
    
    public let trialId: String
    
    public init(trialId: String) {
        self.trialId = trialId
    }
    
}
