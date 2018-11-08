//
//  WSAPTrial.swift
//  iChange
//
//  Created by James Kizer on 4/24/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//
import UIKit

public enum WSAPConfirmationType: String, Codable {
    case timed = "timed"
    case interaction = "interaction"
}

public enum WSAPTrialResponseType: String, Codable {
    case affirmative = "affirmative"
    case negative = "negative"
}

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
    func trialComponent(after trialComponent: WSAPTrialComponent?, with trialComponentResults: [WSAPTrialComponentResult]?, viewController: WSAPStepViewController) -> WSAPTrialComponent?
    func trialResult(trial: WSAPTrial, trialIndex: Int, trialComponentResults: [WSAPTrialComponentResult]) -> WSAPTrialResult?
}

public struct WSAPTrial: Codable {
    public let trialId: String
    public let word: String
    public let sentence: String
    public let crossTime: TimeInterval
    public let wordTime: TimeInterval
    public let affirmativeButtonText: String?
    public let negativeButtonText: String?
    public let confirmation: WSAPConfirmationType?
    public let confirmationTime: TimeInterval?
    public let confirmationText: String?
    public let correctFeedback: [String]?
    public let incorrectFeedback: [String]?
    public let correctResponse: WSAPTrialResponseType
    
    public init(
        trialId: String,
        word: String,
        sentence: String,
        crossTime: TimeInterval,
        wordTime: TimeInterval,
        affirmativeButtonText: String?,
        negativeButtonText: String?,
        confirmation: WSAPConfirmationType?,
        confirmationTime: TimeInterval?,
        confirmationText: String?,
        correctFeedback: [String]?,
        incorrectFeedback: [String]?,
        correctResponse: WSAPTrialResponseType
        ) {
        self.trialId = trialId
        self.word = word
        self.sentence = sentence
        self.wordTime = wordTime
        self.crossTime = crossTime
        self.affirmativeButtonText = affirmativeButtonText
        self.negativeButtonText = negativeButtonText
        self.confirmation = confirmation
        self.confirmationTime = confirmationTime
        self.confirmationText = confirmationText
        self.correctFeedback = correctFeedback
        self.incorrectFeedback = incorrectFeedback
        self.correctResponse = correctResponse
    }
    
}

extension WSAPTrial: WSAPTrialDelegate {
    
    public func trialComponent(after trialComponent: WSAPTrialComponent?, with trialComponentResults: [WSAPTrialComponentResult]?, viewController: WSAPStepViewController) -> WSAPTrialComponent? {
        
        //first blank,
        guard let lastTrialComponent = trialComponent,
            let trialComponentResults = trialComponentResults else {
            return WSAPTrialComponent(
                identifier: "blank",
                presentation: .nothing,
                continuation: .timed(self.crossTime)
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
                continuation: .timed(self.crossTime)
            )
            
            //then, present word
        case "cross":
            return WSAPTrialComponent(
                identifier: "word",
                presentation: .text(self.word),
                continuation: .timed(self.wordTime)
            )
           
            //then present sentence with two buttons
        case "word":
            
            let buttons: [(String, String)] = [
                (WSAPTrialResponseType.affirmative.rawValue, self.affirmativeButtonText ?? "Yes"),
                (WSAPTrialResponseType.negative.rawValue, self.negativeButtonText ?? "No")
            ]
            
            return WSAPTrialComponent(
                identifier: "sentence",
                presentation: .text(self.sentence),
                continuation: .buttons(buttons)
            )
            
        case "sentence":
            //if we should confirm, present depending on whether last response was correct or incorrect
            // - if correct, present correct image w/ randomly selected correct feedback
            // - if incorrect, present incorrect image w/ randomly selected incorrect feedback
            // wait for button press
            guard let confirmation = self.confirmation,
                confirmation == .interaction,
                let componentResult = trialComponentResults.last,
                componentResult.trialComponent.identifier == "sentence" else {
                
                return nil
                
            }
            
            switch componentResult.trialComponentOutcome {
            case .timeExpired(_):
                return nil
                
            case .buttonPressed(let identifier, _):
                guard let response = WSAPTrialResponseType(rawValue: identifier) else {
                    return nil
                }
                
                let correct = self.correctResponse == response
                
                let button: (String, String) = ("next", self.confirmationText ?? "Next")
                
                let presentation: WSAPTrialComponentPresentationType? = {
                    
                    if correct {
                        
                        guard let image = viewController.image(named: "correct") else {
                            return nil
                        }
                        
                        if let feedback = self.correctFeedback?.random() {
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
                        
                        if let feedback = self.incorrectFeedback?.random() {
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
        
        guard let componentResult = trialComponentResults.first(where: {$0.trialComponent.identifier == "sentence"}) else {
                return nil
        }
        
        switch componentResult.trialComponentOutcome {
            
        case .buttonPressed(let identifier, let duration):
            guard let response = WSAPTrialResponseType(rawValue: identifier) else {
                return nil
            }
            
            return WSAPTrialResult(
                trial: trial,
                index: trialIndex,
                responseTime: duration,
                response: response
            )
            
        default:
            return nil
        }
        
    }
    
    
}
