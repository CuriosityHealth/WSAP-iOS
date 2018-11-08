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

    weak var wsapView: NewWSAPView!
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
    
    var responseHandler:((WSAPTrialResponseType) -> Void)?
    
    open override class var showsContinueButton: Bool {
        return false
    }
    
    
    open func initializeImageMap() {
        self.images = {
            var map: [String: UIImage] = [:]
            map["cross"] = {
                if let image = self.wsapStep.crossImage {
                    return image
                }
                else {
                    let bundle = Bundle(for: WSAPStepViewController.self)
                    return UIImage(named: "cross", in: bundle, compatibleWith: nil)
                }
            }()
            
            map["correct"] = {
                if let image = self.wsapStep.correctImage {
                    return image
                }
                else {
                    let bundle = Bundle(for: WSAPStepViewController.self)
                    return UIImage(named: "check", in: bundle, compatibleWith: nil)
                }
            }()
            
            map["incorrect"] = {
                if let image = self.wsapStep.incorrectImage {
                    return image
                }
                else {
                    let bundle = Bundle(for: WSAPStepViewController.self)
                    return UIImage(named: "x", in: bundle, compatibleWith: nil)
                }
            }()
            
            return map
        }()
    }
    
    var images: [String: UIImage]?
    
    open func image(named imageName: String) -> UIImage? {
        
        if self.images == nil {
            self.initializeImageMap()
        }
        
        if let image = self.images?[imageName] {
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
        
        guard let views = bundle.loadNibNamed("NewWSAPView", owner: nil, options: nil),
            let wsapView = views.first as? NewWSAPView,
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
        
        let backgroundNotification: Notification.Name = NSNotification.Name.UIApplicationDidEnterBackground
        self.backgroundObserver = NotificationCenter.default.addObserver(forName: backgroundNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            self?.paused = true
            
        }
        
        let foregroudNotification: Notification.Name = NSNotification.Name.UIApplicationDidBecomeActive
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
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if there are pending trials, don't reset
        if let _ = self.pendingTrials,
            let _ = self.pendingTrialResults {
            return
        }
        
        //clear results
        if let trials = self.trials {
            self.performTrials(trials, results: [], completion: { (results) in
                //                print(results)
                
                self.pendingTrials = nil
                self.pendingTrialResults = nil
                
                if !self.canceled {
                    //set results
                    // results is a list that contains all the trial results - Francesco
                    //                    self.calculateAggregateResults(results)
                    self.trialResults = results
                    self.goForward()
                }
            })
        }
    }
    
    func performTrials(_ trials: [WSAPTrial], results: [WSAPTrialResult], completion: @escaping ([WSAPTrialResult]) -> ()) {
        
        self.pendingTrials = trials
        self.pendingTrialResults = results
        
//        if self.paused {
//            self.pendingTrials = trials
//            self.pendingTrialResults = results
//            return
//        }
        
        if self.canceled {
            completion([])
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
            completion(results)
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
    
    func doTrialComponent(delegate: WSAPTrialDelegate, trialComponent: WSAPTrialComponent, trialComponentResults: [WSAPTrialComponentResult], completion: @escaping ([WSAPTrialComponentResult]) -> ()) {
        
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
            if let nextTrialComponent = delegate.trialComponent(after: trialComponent, with: results, viewController: self) {
                self.doTrialComponent(delegate: delegate, trialComponent: nextTrialComponent, trialComponentResults: results, completion: completion)
            }
            else {
                completion(results)
            }
            
        }
        
    }
    
    func doTrial(trialIndex: Int, trial: WSAPTrial, completion: @escaping (WSAPTrialResult) -> ()) {
        
//        debugPrint(self.contentView)
//        debugPrint(self.wsapView)
        
//        self.wsapView.configureForTrial(trial: trial)
//        self.wsapView.state = .cross
        
//        let wsapView: WSAPxView = self.wsapView
//        let delay = self.delay
        
        let delegate: WSAPTrialDelegate = trial
        let firstTrialComponent: WSAPTrialComponent = delegate.trialComponent(after: nil, with: nil, viewController: self)!
        self.doTrialComponent(
            delegate: delegate,
            trialComponent: firstTrialComponent,
            trialComponentResults: []) { trialComponentResults in
                
                let trialResult: WSAPTrialResult = delegate.trialResult(trial: trial, trialIndex: trialIndex, trialComponentResults: trialComponentResults)!
                completion(trialResult)
                
        }
        
        //ask delegate for first trial result
//        let firstTrialPart = WSAPTrialPart(identifier: "first")
//        let firstTrialComponent =
//        self.doTrialPart(trialPart: firstTrialPart) { trialPartResults in
//            
//            //once trial parts have been completed, ask delegate to generate a result for these trial parts
//            
//            
//        }
        
        
        
//        delay(trial.crossTime) {
//
//            wsapView.state = .word
//            delay(trial.wordTime) {
//
//                //set up for sentence
//
//                let startTime = Date()
//                wsapView.onResponse = { _, response in
//
//                    let endTime = Date()
//                    let responseTime = endTime.timeIntervalSince(startTime)
//
//                    let trialResult = WSAPTrialResult(
//                        trial: trial,
//                        index: trialIndex,
//                        responseTime: responseTime,
//                        response: response
//                    )
//
//                    if trial.confirmation == nil {
//                        completion(trialResult)
//                    }
//                    else {
//                        wsapView.onConfirm = { _ in
//                            completion(trialResult)
//                        }
//
//                        wsapView.state = (response == trial.correctResponse) ? .correct : .incorrect
//                    }
//
//                }
//
//                wsapView.state = .sentence
//
//            }
//
//        }
        
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
            
            parentResult.results = [wsapResult]
        }
        
        return parentResult
    }

}
