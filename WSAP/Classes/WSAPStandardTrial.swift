//
//  WSAPStandardTrial.swift
//  WSAP
//
//  Created by James Kizer on 11/8/18.
//

import UIKit

public enum WSAPStandardTrialResponseType: String, Codable {
    case affirmative = "affirmative"
    case negative = "negative"
}

public struct WSAPTrialFeedback {
    public let feedbackButtonText: String
    public let correctFeedback: [String]
    public let incorrectFeedback: [String]
    
    public init(
        feedbackButtonText: String,
        correctFeedback: [String],
        incorrectFeedback: [String]
        ) {
        self.feedbackButtonText = feedbackButtonText
        self.correctFeedback = correctFeedback
        self.incorrectFeedback = incorrectFeedback
    }
}

open class WSAPStandardTrial: WSAPTrial {
    public let word: String
    public let sentence: String
    public let crossTime: TimeInterval
    public let wordTime: TimeInterval
    public let affirmativeButtonText: String?
    public let negativeButtonText: String?
    public let correctResponse: WSAPStandardTrialResponseType
    
    public let feedback: WSAPTrialFeedback?
    
    public init(
        trialId: String,
        word: String,
        sentence: String,
        crossTime: TimeInterval,
        wordTime: TimeInterval,
        affirmativeButtonText: String?,
        negativeButtonText: String?,
        correctResponse: WSAPStandardTrialResponseType,
        feedback: WSAPTrialFeedback?
        ) {
        
        self.word = word
        self.sentence = sentence
        self.wordTime = wordTime
        self.crossTime = crossTime
        self.affirmativeButtonText = affirmativeButtonText
        self.negativeButtonText = negativeButtonText
        self.correctResponse = correctResponse
        self.feedback = feedback
        
        super.init(trialId: trialId)
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override open func trialDelegate() -> WSAPTrialDelegate {
        return WSAPStandardTrialDelegate.shared
    }
    
}

public class WSAPStandardTrialDelegate: WSAPTrialDelegate {
    
    static let shared = WSAPStandardTrialDelegate()
    
    public func trialComponent(trial: WSAPTrial, lastTrialComponent: WSAPTrialComponent?, trialComponentResults: [WSAPTrialComponentResult]?, viewController: WSAPStepViewController) -> WSAPTrialComponent? {
        
        guard let trial = trial as? WSAPStandardTrial else {
            assertionFailure("Trial must be a standard trial")
            return nil
        }
        
        //first blank,
        guard let lastTrialComponent = lastTrialComponent,
            let trialComponentResults = trialComponentResults else {
                return WSAPTrialComponent(
                    identifier: "blank",
                    presentation: .nothing,
                    continuation: .timed(trial.crossTime)
                )
        }
        
        switch lastTrialComponent.identifier {
        //then, present cross
        case "blank":
            guard let image = viewController.image(named: "cross") else {
                return nil
            }
            
            return WSAPTrialComponent(
                identifier: "cross",
                presentation: .image(image),
                continuation: .timed(trial.crossTime)
            )
            
        //then, present word
        case "cross":
            return WSAPTrialComponent(
                identifier: "word",
                presentation: .text(trial.word),
                continuation: .timed(trial.wordTime)
            )
            
        //then present sentence with two buttons
        case "word":
            
            let buttons: [(String, String)] = [
                (WSAPStandardTrialResponseType.affirmative.rawValue, trial.affirmativeButtonText ?? "Yes"),
                (WSAPStandardTrialResponseType.negative.rawValue, trial.negativeButtonText ?? "No")
            ]
            
            return WSAPTrialComponent(
                identifier: "sentence",
                presentation: .text(trial.sentence),
                continuation: .buttons(buttons)
            )
            
        case "sentence":
            //if we should confirm, present depending on whether last response was correct or incorrect
            // - if correct, present correct image w/ randomly selected correct feedback
            // - if incorrect, present incorrect image w/ randomly selected incorrect feedback
            // wait for button press
            guard let feedback = trial.feedback,
                let componentResult = trialComponentResults.last,
                componentResult.trialComponent.identifier == "sentence" else {
                    
                    return nil
                    
            }
            
            switch componentResult.trialComponentOutcome {
            case .timeExpired(_):
                return nil
                
            case .buttonPressed(let identifier, _):
                guard let response = WSAPStandardTrialResponseType(rawValue: identifier) else {
                    return nil
                }
                
                let correct = trial.correctResponse == response
                
                let button: (String, String) = ("next", feedback.feedbackButtonText)
                
                let presentation: WSAPTrialComponentPresentationType? = {
                    
                    if correct {
                        
                        guard let image = viewController.image(named: "correct") else {
                            return nil
                        }
                        
                        if let feedback = feedback.correctFeedback.random() {
                            return WSAPTrialComponentPresentationType.imageWithText(image, feedback)
                        }
                        else {
                            return WSAPTrialComponentPresentationType.image(image)
                        }
                        
                    }
                    else {
                        guard let image = viewController.image(named: "incorrect") else {
                            return nil
                        }
                        
                        if let feedback = feedback.incorrectFeedback.random() {
                            return WSAPTrialComponentPresentationType.imageWithText(image, feedback)
                        }
                        else {
                            return WSAPTrialComponentPresentationType.image(image)
                        }
                        
                    }
                    
                }()
                
                if let presentation = presentation {
                    return WSAPTrialComponent(
                        identifier: "feedback",
                        presentation: presentation,
                        continuation: .buttons([button])
                    )
                }
                else {
                    return nil
                }
                
            }
            
        default:
            return nil
        }
        
        return nil
        
    }
    
    public func trialResult(trial: WSAPTrial, trialIndex: Int, trialComponentResults: [WSAPTrialComponentResult]) -> WSAPTrialResult? {
        
        guard let trial = trial as? WSAPStandardTrial,
            let componentResult = trialComponentResults.first(where: {$0.trialComponent.identifier == "sentence"}) else {
            return nil
        }
        
        switch componentResult.trialComponentOutcome {
            
        case .buttonPressed(let identifier, let duration):
            guard let response = WSAPStandardTrialResponseType(rawValue: identifier) else {
                return nil
            }
            
            return WSAPStandardTrialResult(
                index: trialIndex,
                trial: trial,
                responseTime: duration,
                response: response
            )
            
        default:
            return nil
        }
        
    }
    
    
}
