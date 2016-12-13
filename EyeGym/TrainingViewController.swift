//
//  ViewController.swift
//  EyeGym
//
//  Created by Мануэль on 07.02.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

internal enum userSettingsKeys: String
{
    case intensityStepperValue
    case trainingTime
}

class TrainingViewController: UIViewController, SegueHandlerType
{
    internal enum SegueID: String
    {
        case InstructionsViewController
    }
    
    private let minimumTrainingDistance = 45
    
    private let userDefaults = UserDefaults()
    
    var isIntroAppeared = false
    
    private var trainingDistance = 120 //maximum is 120, minimum is 45 for now
    
    private var intensity = 3 {
        didSet {
            trainingDistance = minimumTrainingDistance + intensity * 15
            
            setIntensityLabelText()
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
    
    fileprivate var isStarted = false {
        didSet {
            isStarted ? prepareForTraining() : stopTraining()
        }
    }
    
    @IBOutlet weak var intensityLabel:         UILabel!
    @IBOutlet weak var trainingTimerLabel:     UILabel!
    @IBOutlet weak var infoButton:             UIButton!
    @IBOutlet weak var backgroundImageView:    UIImageView!
    @IBOutlet weak var rightImage:             TrainingObjectView!
    @IBOutlet weak var leftImage:              TrainingObjectView!
    @IBOutlet weak var startButton:            StartButton!
    @IBOutlet weak var timeIntervalSegControl: UISegmentedControl!
    @IBOutlet weak var controlPanelStackView:  UIStackView!
    @IBOutlet weak var intensityStepper:       UIStepper!
    
    @IBAction func stopTraining(_ sender: UITapGestureRecognizer) { isStarted = false }
    
    @IBAction func start() { isStarted = true }
    
    @IBAction func showIntro(_ sender: UIButton) {
        
        showIntroductionView()
    }
    
    @IBAction func intensityChanged(_ sender: UIStepper) {
        
        intensity = Int(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadValues() // Load saved training settings
        
        leftImage.image           = UIImage(withAsset: .earth)
        rightImage.image          = UIImage(withAsset: .earth)
        backgroundImageView.image = UIImage(withAsset: .space)
        
        leftImage.animationDelegate      = self
        rightImage.animationDelegate     = self
        infoButton.tintColor             = view.tintColor
        timeIntervalSegControl.tintColor = view.tintColor
        trainingTimerLabel.textColor     = view.tintColor
        intensityLabel.textColor         = view.tintColor
        trainingTimerLabel.text          = "Время тренировки"
        
        intensity = Int(intensityStepper.value)
        
        setIntensityLabelText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        startButton.textForMask = "Старт"
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let introWasShown = userDefaults.bool(forKey: UserDefaultsKeys.wasShown.rawValue)
        
        if !introWasShown
        {
            showIntroductionView()
            
            userDefaults.set(true, forKey: UserDefaultsKeys.wasShown.rawValue)
        }
    }
    
    private func showIntroductionView() {
        
        isIntroAppeared = true
        
        toggleHideAll()
        
        let controller = storyboard!.instantiateViewController(withIdentifier: .introductionVC) as! IntroductionViewController
        
        controller.trainingVC = self
        
        present(controller, animated: true, completion: nil)
    }
    
    //Triggered by bool property isStarted
    private func stopTraining() {
        
        leftImage.layer.removeAllAnimations()
        rightImage.layer.removeAllAnimations()
        
        traningPreparationSpinner?.removeFromSuperlayer()
        
        toggleControlsHiding()
    }
    
    func toggleHideAll() {
       
        let value: CGFloat = isIntroAppeared ? 0 : 1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.infoButton.alpha            = value
            self.startButton.alpha           = value
            self.leftImage.alpha             = value
            self.rightImage.alpha            = value
            self.controlPanelStackView.alpha = value
        })        
    }
    
    private func toggleControlsHiding() {
        
        let value: CGFloat = isStarted ? 0 : 1
        
        UIView.animate(withDuration: 0.7) {
            self.infoButton.alpha            = value
            self.startButton.alpha           = value
            self.controlPanelStackView.alpha = value
        }
    }
    
    //Triggered by bool property isStarted
    private func prepareForTraining() {
        
        saveValues()
        toggleControlsHiding()
        
        let point = CGPoint(
            x: controlPanelStackView.bounds.width / 2,
            y: controlPanelStackView.bounds.height / 2)
        
        traningPreparationSpinner = OvalShapeLayer(point: point)
        
        delay(seconds: 5) {
            guard self.isStarted else { return }
            
            let distance = CGFloat(self.trainingDistance)
            
            self.leftImage.animate(with: self.requestedTimer, direction: .left, distance: distance)
            self.rightImage.animate(with: self.requestedTimer, direction: .right, distance: distance)
        }
    }
    
    private func setIntensityLabelText() {
        intensityLabel.text = "Интенсивность: \(intensity)"
    }
    
    private func saveValues() {
        userDefaults.set(intensityStepper.value, forKey: userSettingsKeys.intensityStepperValue.rawValue)
        userDefaults.set(timeIntervalSegControl.selectedSegmentIndex, forKey: userSettingsKeys.trainingTime.rawValue)
    }
    
    private func loadValues() {
        timeIntervalSegControl.selectedSegmentIndex = userDefaults.integer(forKey: userSettingsKeys.trainingTime.rawValue)
        intensityStepper.value = userDefaults.double(forKey: userSettingsKeys.intensityStepperValue.rawValue)
    }
}

extension TrainingViewController: CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        isStarted = false
    }
}







