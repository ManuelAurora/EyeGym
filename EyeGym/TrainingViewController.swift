//
//  ViewController.swift
//  EyeGym
//
//  Created by Мануэль on 07.02.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class TrainingViewController: UIViewController, SegueHandlerType
{
    internal enum SegueID: String
    {
        case InstructionsViewController
    }
    
    private let maxDistance: CGFloat = 150
    
    fileprivate var isStarted = false {
        didSet {
            isStarted ? prepareForTraining() : stopTraining()
        }
    }
    
    private var traningPreparationSpinner: OvalShapeLayer? {
        didSet {
            controlPanelStackView.layer.addSublayer(traningPreparationSpinner!)
        }
    }
    
    private var requestedTimer: Double {
        
        switch timeIntervalSegControl.selectedSegmentIndex
        {
        case 0:  return 60.0
        case 1:  return 90.0
        case 2:  return 120.0
        default: return 60.0
        }
    }
    
    @IBOutlet weak var infoButton:             UIButton!
    @IBOutlet weak var backgroundImageView:    UIImageView!
    @IBOutlet weak var rightImage:             TrainingObjectView!
    @IBOutlet weak var leftImage:              TrainingObjectView!
    @IBOutlet weak var startButton:            StartButton!
    @IBOutlet weak var controlPanelStackView:  UIStackView!
    @IBOutlet weak var timeIntervalSegControl: UISegmentedControl!
    
    @IBAction func stopTraining(_ sender: UITapGestureRecognizer) { isStarted = false }
    
    @IBAction func start() { isStarted = true }
    
    @IBAction func showIntro(_ sender: UIButton) {
        
        showIntroductionView()
    }
    
    override func viewDidLoad() {
        
        leftImage.image           = UIImage(withAsset: .earth)
        rightImage.image          = UIImage(withAsset: .earth)
        backgroundImageView.image = UIImage(withAsset: .space)
        
        leftImage.animationDelegate      = self
        rightImage.animationDelegate     = self
        infoButton.tintColor             = view.tintColor
        timeIntervalSegControl.tintColor = view.tintColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        startButton.textForMask = "Start"
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults()
        
        let introWasShown = defaults.bool(forKey: UserDefaultsKeys.wasShown.rawValue)
        
        if !introWasShown
        {
            showIntroductionView()
            
            defaults.set(true, forKey: UserDefaultsKeys.wasShown.rawValue)
        }
    }
    
    private func showIntroductionView() {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: .introductionVC)
        
        present(controller, animated: true, completion: nil)
    }
    
    //Triggered by bool property isStarted
    private func stopTraining() {
        
        leftImage.layer.removeAllAnimations()
        rightImage.layer.removeAllAnimations()
        
        traningPreparationSpinner?.removeFromSuperlayer()
        
        toggleControlsHiding()
    }
    
    private func toggleControlsHiding() {
        
        let value: CGFloat = isStarted ? 0 : 1
        
        UIView.animate(withDuration: 0.7) {
            self.infoButton.alpha             = value
            self.startButton.alpha            = value
            self.timeIntervalSegControl.alpha = value
        }
    }
    
    //Triggered by bool property isStarted
    private func prepareForTraining() {
        
        toggleControlsHiding()
        
        let point = CGPoint(
            x: controlPanelStackView.bounds.width / 2,
            y: controlPanelStackView.bounds.height / 2)
        
        traningPreparationSpinner = OvalShapeLayer(point: point)
        
        delay(seconds: 5) {
            guard self.isStarted else { return }
            
            self.leftImage.animate(with: self.requestedTimer, direction: .left, distance: self.maxDistance)
            self.rightImage.animate(with: self.requestedTimer, direction: .right, distance: self.maxDistance)
        }
    }
}

extension TrainingViewController: CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        isStarted = false
    }
}







