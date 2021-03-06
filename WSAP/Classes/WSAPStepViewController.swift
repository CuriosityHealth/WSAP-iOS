//
//  WSAPStepViewController.swift
//  iChange
//
//  Created by James Kizer on 4/17/17.
//  Copyright © 2017 CuriosityHealth. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteExtensions

open class WSAPStepViewController: RSQuestionViewController {

    weak var wsapView: WSAPView!
    var wsapStep: WSAPStep! {
        return self.step as! WSAPStep
    }
    
    var trials: [WSAPTrial]?
    var trialResults: [WSAPTrialResult]?
    
    var canceled = false
    var paused = false
    var pendingTrials: [WSAPTrial]?
    var pendingTrialResults: [WSAPTrialResult]?
    var backgroundObserver: NSObjectProtocol!
    var foregroundObserver: NSObjectProtocol!
    
    var startTime: Date = Date()
    var interruptionCount = 0
    var completed: Bool = false
    
    open override class var showsContinueButton: Bool {
        return false
    }
    
    open func image(named imageName: String) -> UIImage? {
        
        if let image = self.wsapStep.imageMap[imageName] {
            return image
        }
        else {
            return UIImage(named: imageName)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: WSAPStepViewController.self)
//        guard let views = bundle.loadNibNamed("WSAPView", owner: nil, options: nil),
//            let wsapView = views.first as? WSAPView,
//            let wsapStep = self.step as? WSAPStep else {
//                fatalError()
//        }
        
        guard let views = bundle.loadNibNamed("WSAPView", owner: nil, options: nil),
            let wsapView = views.first as? WSAPView,
            let wsapStep = self.step as? WSAPStep else {
                fatalError()
        }
        
        self.trials = wsapStep.trials
        
        self.wsapView = wsapView
        
//        self.wsapView.crossImage = {
//            if let image = wsapStep.crossImage {
//                return image
//            }
//            else {
//                let bundle = Bundle(for: WSAPStepViewController.self)
//                return UIImage(named: "cross", in: bundle, compatibleWith: nil)
//            }
//        }()
//
//        self.wsapView.correctImage = {
//            if let image = wsapStep.correctImage {
//                return image
//            }
//            else {
//                let bundle = Bundle(for: WSAPStepViewController.self)
//                return UIImage(named: "check", in: bundle, compatibleWith: nil)
//            }
//        }()
//
//        self.wsapView.incorrectImage = {
//            if let image = wsapStep.incorrectImage {
//                return image
//            }
//            else {
//                let bundle = Bundle(for: WSAPStepViewController.self)
//                return UIImage(named: "x", in: bundle, compatibleWith: nil)
//            }
//        }()
//
//        self.wsapView.state = .cross
        self.wsapView.progress = 0.0
        self.wsapView.progressView.progressLabel.isHidden = true
        self.contentView.addSubview(self.wsapView)
        self.wsapView.frame = self.contentView.bounds
//        debugPrint(self.contentView)
        
        let backgroundNotification: Notification.Name = UIApplication.didEnterBackgroundNotification
        self.backgroundObserver = NotificationCenter.default.addObserver(forName: backgroundNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            self?.paused = true
            self?.interruptionCount = {
                if let interruptionCount = self?.interruptionCount {
                    return interruptionCount + 1
                }
                else {
                    return 1
                }
            }()
            
        }
        
        let foregroudNotification: Notification.Name = UIApplication.didBecomeActiveNotification
        self.foregroundObserver = NotificationCenter.default.addObserver(forName: foregroudNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            self?.paused = false
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.backgroundObserver)
        NotificationCenter.default.removeObserver(self.foregroundObserver)
    }
    
    
//    //MARK: Perform the trials
//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if let trials = self.pendingTrials,
//            let trialResults = self.pendingTrialResults {
//            self.performTrials(trials, results: trialResults, completion: { (results) in
//                if !self.canceled {
//                    self.trialResults = results
//                    self.goForward()
//                }
//            })
//        }
//        else if let trials = self.trials {
//            self.performTrials(trials, results: [], completion: { (results) in
//                if !self.canceled {
//                    self.trialResults = results
//                    self.goForward()
//                }
//            })
//        }
//    }
    
    open func shouldEnd(startTime: Date, interruptionCount: Int) -> Bool {
        guard let delegate = self.wsapStep.timeoutInterruptionDelegate else {
            return false
        }
        
        return delegate.shouldEnd(startTime: startTime, interruptionCount: interruptionCount)
    }
    
    open func presentInterruptionAlert(startTime: Date, interruptionCount: Int, completion: @escaping () -> ()) {
        
        guard let delegate = self.wsapStep.timeoutInterruptionDelegate else {
            assertionFailure("We shouldn't be able to get here since shouldEnd requires a delegate")
            return
        }
        
        let (title, message) = delegate.interruptionAlertTitleAndMessage(startTime: startTime, interruptionCount: interruptionCount)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            completion()
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if there are pending trials, don't reset
        if let _ = self.pendingTrials,
            let _ = self.pendingTrialResults {
            return
        }
        
        //clear results
        if let trials = self.trials {
            self.performTrials(trials, results: [], completion: { (results, completed) in
                //                print(results)
                
                self.pendingTrials = nil
                self.pendingTrialResults = nil
                
                self.trialResults = results
                self.completed = completed
                
                if completed {
                    self.goForward()
                }
                else {
                    self.presentInterruptionAlert(startTime: self.startTime, interruptionCount: self.interruptionCount, completion: {
                        self.goForward()
                    })
                }
                
            })
        }
    }
    
    func performTrials(_ trials: [WSAPTrial], results: [WSAPTrialResult], completion: @escaping ([WSAPTrialResult], Bool) -> ()) {
        
        self.pendingTrials = trials
        self.pendingTrialResults = results
        
//        if self.paused {
//            self.pendingTrials = trials
//            self.pendingTrialResults = results
//            return
//        }
        
        //check for ending based on start time and interruption count
        if self.shouldEnd(startTime: self.startTime, interruptionCount: self.interruptionCount) {
            completion(results, false)
            return
        }
        
        if trials.count > results.count {
            let trialIndex = results.count
            let trial = trials[trialIndex]
            let progress: Float = Float(trialIndex) / Float(trials.count)
            self.wsapView.progress = progress
            self.doTrial(trialIndex: trialIndex, trial: trial, completion: { (result) in
                let newResults = results + [result]
                self.performTrials(trials, results: newResults, completion: completion)
            })
        }
        else {
            completion(results, true)
        }
        
//        if let head = trials.first {
//            let tail = Array(trials.dropFirst())
//            let progress: Float = Float(results.count) / Float(trials.count)
//            self.wsapView.progress = progress
//            self.doTrial(trialIndex: results.count, trial: head, completion: { (result) in
//                let newResults = results + [result]
//                self.performTrials(tail, results: newResults, completion: completion)
//            })
//        }
//        else {
//            completion(results)
//        }
        
    }
    
    
    func delay(_ delay:TimeInterval, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func doTrialComponent(trial: WSAPTrial, delegate: WSAPTrialDelegate, trialComponent: WSAPTrialComponent, trialComponentResults: [WSAPTrialComponentResult], completion: @escaping ([WSAPTrialComponentResult]) -> ()) {
        
        //next, update presentation and continuation
        self.wsapView.updateForTrialComponent(trialComponent: trialComponent) { (outcome) in
            
            //when continuation completes, get next trial part from delegate, generate trial part result
            //if there is a next trial part, recurse
            //otherwise, call completion
            
            let trialComponentResult = WSAPTrialComponentResult(
                trialComponent: trialComponent,
                trialComponentOutcome: outcome
            )
            
            let results = trialComponentResults + [trialComponentResult]
            if let nextTrialComponent = delegate.trialComponent(trial: trial, lastTrialComponent: trialComponent, trialComponentResults: results, viewController: self) {
                self.doTrialComponent(trial: trial, delegate: delegate, trialComponent: nextTrialComponent, trialComponentResults: results, completion: completion)
            }
            else {
                completion(results)
            }
            
        }
        
    }
    
    open func trialDelegate(for trial: WSAPTrial) -> WSAPTrialDelegate {
        return trial.trialDelegate()
    }
    
    func doTrial(trialIndex: Int, trial: WSAPTrial, completion: @escaping (WSAPTrialResult) -> ()) {
        
        let delegate: WSAPTrialDelegate = self.trialDelegate(for: trial)
        let firstTrialComponent: WSAPTrialComponent = delegate.trialComponent(trial: trial, lastTrialComponent: nil, trialComponentResults: nil, viewController: self)!
        
        self.doTrialComponent(
            trial: trial,
            delegate: delegate,
            trialComponent: firstTrialComponent,
            trialComponentResults: []) { trialComponentResults in
                
                let trialResult: WSAPTrialResult = delegate.trialResult(trial: trial, trialIndex: trialIndex, trialComponentResults: trialComponentResults)!
                completion(trialResult)
                
        }
        
    }
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if let trialResults = self.trialResults {
            
            let wsapResult = WSAPResult(identifier: step!.identifier)
            wsapResult.startDate = parentResult.startDate
            wsapResult.endDate = parentResult.endDate
            wsapResult.trialResults = trialResults
            wsapResult.interruptionCount = self.interruptionCount
            wsapResult.completed = self.completed
            
            parentResult.results = [wsapResult]
        }
        
        return parentResult
    }

}
