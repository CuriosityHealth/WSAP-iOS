//
//  NewWSAPView.swift
//  WSAP
//
//  Created by James Kizer on 11/7/18.
//

import UIKit
import ResearchSuiteExtensions
import SnapKit

open class NewWSAPView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var primaryTextLabel: WSAPLabel!
    @IBOutlet weak var secondaryTextLabel: WSAPFeedbackLabel!
    
    @IBOutlet weak var progressView: WSAPProgressView!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.updatePresentation(presentation: .nothing)
        self.updateContinuation(continuation: .nothing) { (outcome) in
            
        }
        
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

    func updatePresentation(presentation: WSAPTrialComponentPresentationType) {
        
        switch presentation {
            
        case .nothing:
            self.imageView.image = nil
            self.imageView.isHidden = true
            self.primaryTextLabel.text = nil
            self.primaryTextLabel.isHidden = true
            self.secondaryTextLabel.text = nil
            self.secondaryTextLabel.isHidden = true
            
        case .image(let image):
            self.imageView.image = image
            self.imageView.isHidden = false
            self.primaryTextLabel.text = nil
            self.primaryTextLabel.isHidden = true
            self.secondaryTextLabel.text = nil
            self.secondaryTextLabel.isHidden = true
            
        case .imageWithText(let image, let text):
            self.imageView.image = image
            self.imageView.isHidden = false
            self.primaryTextLabel.text = nil
            self.primaryTextLabel.isHidden = true
            self.secondaryTextLabel.text = text
            self.secondaryTextLabel.isHidden = false
            
        case .text(let text):
            self.imageView.image = nil
            self.imageView.isHidden = true
            self.primaryTextLabel.text = text
            self.primaryTextLabel.isHidden = false
            self.secondaryTextLabel.text = nil
            self.secondaryTextLabel.isHidden = true
            
        }
        
    }
    
    func delay(_ delay:TimeInterval, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func updateContinuation(continuation: WSAPTrialComponentContinuationType, completion: @escaping (WSAPTrialComponentOutcomeType) -> ()) {
        
        self.buttonStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        switch continuation {
        case .nothing:
            break
            
        case .timed(let duration):
            let startTime = Date()
            self.delay(duration) {
                let endTime = Date()
                let outcome = WSAPTrialComponentOutcomeType.timeExpired(duration: endTime.timeIntervalSince(startTime))
                completion(outcome)
            }
            
        case .buttons(let buttonDescriptors):

            var startTime: Date!
            
            buttonDescriptors.forEach { (identifier, buttonTitle) in
                
                let buttonContainer = UIView()
                self.buttonStackView.addArrangedSubview(buttonContainer)
                
                let button = RSBorderedButton(type: .custom)
                button.setTitle(buttonTitle, for: .normal)
                
                buttonContainer.addSubview(button)
                
                //set constraints
                button.snp.makeConstraints { (make) in
                    make.height.equalTo(44)
                    make.width.greaterThanOrEqualTo(150)
                    make.center.equalToSuperview()
                }
                
                //set action
                let buttonCompletion: (Date)->() = { endTime in
                    
                    self.buttonStackView.isUserInteractionEnabled = false
                    let outcome = WSAPTrialComponentOutcomeType.buttonPressed(identifier: identifier, duration: endTime.timeIntervalSince(startTime))
                    completion(outcome)
                    
                }
                
                button.userInfo = ["buttonCompletion": buttonCompletion]
                
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            }
            
            self.buttonStackView.isUserInteractionEnabled = true
            startTime = Date()
            
            break
            
        }
        
    }
    
    open func updateForTrialComponent(trialComponent: WSAPTrialComponent, completion: @escaping (WSAPTrialComponentOutcomeType) -> ()) {

        self.updatePresentation(presentation: trialComponent.presentation)
        self.updateContinuation(continuation: trialComponent.continuation, completion: completion)
        
    }
    
    @objc func buttonTapped(_ sender: RSBorderedButton) {
        let endTime = Date()
        guard let buttonCompletion: (Date)->() = sender.userInfo?["buttonCompletion"] as? (Date)->() else {
            assertionFailure("Expecting completion to be set in userInfo")
            return
        }
        
        buttonCompletion(endTime)
    }
    
    
    
    
}
