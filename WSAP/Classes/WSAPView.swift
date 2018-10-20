//
//  WSAPView.swift
//  iChange
//
//  Created by James Kizer on 4/16/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//

import UIKit
import ResearchSuiteExtensions

public enum WSAPViewState {
    case blank
    case cross
    case word
    case sentence
    case correct
    case incorrect
}

open class WSAPView: UIView {
    
    public typealias OnResponse = (WSAPView, WSAPTrialResponseType) -> Void
    public typealias OnConfirm = (WSAPConfirmationType) -> Void

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var crossImageView: UIImageView!
    
    @IBOutlet weak var affirmativeButton: RSBorderedButton!
    @IBOutlet weak var negativeButton: RSBorderedButton!
    
    @IBOutlet weak var progressView: WSAPProgressView!
    
    public var onResponse: OnResponse!
    public var onConfirm: OnConfirm!
    
    @IBOutlet weak var confirmationButton: RSBorderedButton!
    
    public var crossImage: UIImage!
    public var incorrectImage: UIImage!
    public var correctImage: UIImage!
    
    var trial: WSAPTrial!

    func configureForTrial(trial: WSAPTrial) {
        //clear state
        self.trial = trial
        self.state = .cross
        self.affirmativeButton.setTitle(trial.affirmativeButtonText, for: .normal)
        self.negativeButton.setTitle(trial.negativeButtonText, for: .normal)
        let confirmationText = trial.confirmationText ?? "Confirm"
        self.confirmationButton.setTitle(confirmationText, for: .normal)
    }
    
    
    var state: WSAPViewState = .blank {
        didSet {
            self.crossImageView.isHidden = {
                switch self.state {
                case .word:
                    return true
                case .sentence:
                    return true
                default:
                    return false
                }
            }()
            
            self.crossImageView.image = {
//                let bundle = Bundle(for: WSAPView.self)
                let bundle = Bundle.main
                switch self.state {
                case .correct:
                    return self.correctImage
                case .incorrect:
                    return self.incorrectImage
                case .cross:
                    return self.crossImage
                default:
                    return nil
                }
            }()
            
            self.feedbackLabel.isHidden = !(self.state == .correct || self.state == .incorrect)
            self.feedbackLabel.text = self.selectFeedbackText(state: self.state, trial: self.trial)
            
            self.textLabel.isHidden = self.state == .blank
            self.affirmativeButton.isHidden = !(self.state == .sentence)
            self.negativeButton.isHidden = !(self.state == .sentence)
            
            self.textLabel.text = {
                switch self.state {
                case .word:
                    return self.trial?.word
                case .sentence:
                    return self.trial?.sentence
                default:
                    return nil
                }
            }()
            
            if self.state == .correct || self.state == .incorrect {
                switch self.trial.confirmation {
                    
                case .some(.interaction):
                    self.confirmationButton.isHidden = false
                    
                case .some(.timed):
                    delay(self.trial.confirmationTime!) {
                        self.onConfirm(.timed)
                    }
                default:
                    break
                }
                
            }
            else {
                self.confirmationButton.isHidden = true
            }
        }
    }
    
    private func selectFeedbackText(state: WSAPViewState, trial: WSAPTrial?) -> String? {
        switch state {
        case .correct:
            return trial?.correctFeedback?.random()
        case .incorrect:
            return trial?.incorrectFeedback?.random()
        default:
            return nil
        }
    }
    
    func delay(_ delay:TimeInterval, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    open var progress: Float {
        get {
            return self.progressView.progress
        }
        set(newProgress) {
            self.progressView.setProgress(newProgress, animated: true)
        }
    }
    
    private func setProgress(progress: Float) {
        self.progressView.progress = progress
    }

    @IBAction func tappedAffirmativeButton(_ sender: Any) {
        self.onResponse(self, .affirmative)
    }
    
    @IBAction func tappedNegativeButton(_ sender: Any) {
        self.onResponse(self, .negative)
    }
    @IBAction func tappedConfirmationButton(_ sender: Any) {
        self.onConfirm(.interaction)
    }
}
