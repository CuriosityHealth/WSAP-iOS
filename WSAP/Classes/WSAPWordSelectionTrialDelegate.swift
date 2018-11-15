//
//  WSAPWordSelectionTrialDelegate.swift
//  WSAP
//
//  Created by James Kizer on 11/8/18.
//

import UIKit

public class WSAPWordSelectionTrialDelegate: WSAPTrialDelegate {
    
    static let shared = WSAPWordSelectionTrialDelegate()
    
    public func trialComponent(trial: WSAPTrial, lastTrialComponent: WSAPTrialComponent?, trialComponentResults: [WSAPTrialComponentResult]?, viewController: WSAPStepViewController) -> WSAPTrialComponent? {
        
        guard let trial = trial as? WSAPWordSelectionTrial else {
            assertionFailure("Trial must be a word selection trial")
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
            
        //then, present sentence
        case "cross":
            
            return WSAPTrialComponent(
                identifier: "sentence",
                presentation: .text(trial.sentence),
                continuation: .timed(trial.sentenceTime)
            )
            
        //then present words for selection
        case "sentence":
            
            let buttons: [(String, String)] = [
                (WSAPWordSelectionTrialResponseType.left.rawValue, trial.leftWord),
                (WSAPWordSelectionTrialResponseType.right.rawValue, trial.rightWord)
            ]
            
            return WSAPTrialComponent(
                identifier: "words",
                presentation: .text(trial.sentence),
                continuation: .buttons(buttons)
            )
            
        case "words":
            //if we should confirm, present depending on whether last response was correct or incorrect
            // - if correct, present correct image w/ randomly selected correct feedback
            // - if incorrect, present incorrect image w/ randomly selected incorrect feedback
            // wait for button press
            guard let feedback = trial.feedback,
                let componentResult = trialComponentResults.last,
                componentResult.trialComponent.identifier == "words" else {
                    
                    return nil
                    
            }
            
            switch componentResult.trialComponentOutcome {
            case .timeExpired(_):
                return nil
                
            case .buttonPressed(let identifier, _):
                guard let response = WSAPWordSelectionTrialResponseType(rawValue: identifier) else {
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
        
    }
    
    public func trialResult(trial: WSAPTrial, trialIndex: Int, trialComponentResults: [WSAPTrialComponentResult]) -> WSAPTrialResult? {
        
        guard let trial = trial as? WSAPWordSelectionTrial,
//            let sentenceComponentResult = trialComponentResults.first(where: {$0.trialComponent.identifier == "sentence"}),
            let wordsComponentResult = trialComponentResults.first(where: {$0.trialComponent.identifier == "words"}) else {
                return nil
        }
        
//        let sentenceResponseTimeOpt: TimeInterval? = {
//            switch sentenceComponentResult.trialComponentOutcome {
//
//            case .buttonPressed(_, let duration):
//                return duration
//
//            default:
//                return nil
//            }
//        }()
        
        let pairOpt: (WSAPWordSelectionTrialResponseType, TimeInterval)?  = {
            switch wordsComponentResult.trialComponentOutcome {
                
            case .buttonPressed(let identifier, let duration):
                guard let response = WSAPWordSelectionTrialResponseType(rawValue: identifier) else {
                    return nil
                }
                
                return (response, duration)
                
            default:
                return nil
            }
            
        }()
        
//        guard let sentenceResponseTime = sentenceResponseTimeOpt,
//            let pair = pairOpt else {
//            return nil
//        }

        guard let pair = pairOpt else {
                return nil
        }
        
        return WSAPWordSelectionTrialResult(
            index: trialIndex,
            trial: trial,
//            sentenceResponseTime: sentenceResponseTime,
            wordsResponseTime: pair.1,
            response: pair.0
        )
        
    }
    
    
}
