//
//  ViewController.swift
//  EyeGym
//
//  Created by Мануэль on 07.02.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import StoreKit

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
    private let imageTag                = 100500
    private let inAppID                 = "com.aurorainterplay.EyeGym.FullVersion"
    private let userDefaults            = UserDefaults()
    private var trainingDistance        = 120 //maximum is 120, minimum is 45 for now
    
    var isIntroAppeared     = false
    
    lazy var animator = TransitionAnimator()
    
    private var optionsMenu:  UIView?
    private var optionsView:  OptionsView!
    private var optionsImageView = UIImageView()
    
    private var intensity = 3 {
        didSet {
            trainingDistance = minimumTrainingDistance + intensity * 15
            
            setIntensityLabelText()
        }
    }
    
    private var trainingPreparationSpinner: OvalShapeLayer? {
        didSet {
            view.layer.addSublayer(trainingPreparationSpinner!)
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
    
    fileprivate var isOptionsMenuOpened = false {
        didSet {
            isOptionsMenuOpened ? openOptionsMenu() : closeOptionsMenu()
        }
    }
    
    @IBOutlet weak var intensityLabel:          UILabel!
    @IBOutlet weak var trainingTimerLabel:      UILabel!
    @IBOutlet weak var infoButton:              UIButton!
    @IBOutlet weak var optionsButton:           UIButton!
    @IBOutlet weak var backgroundImageView:     UIImageView!
    @IBOutlet weak var rightImage:              TrainingObjectView!
    @IBOutlet weak var leftImage:               TrainingObjectView!
    @IBOutlet weak var startButton:             StartButton!
    @IBOutlet weak var timeIntervalSegControl:  UISegmentedControl!
    @IBOutlet weak var controlPanelStackView:   UIStackView!
    @IBOutlet weak var trainingFieldStackView:  UIStackView!
    @IBOutlet weak var intensityPanelStackView: UIStackView!
    @IBOutlet weak var timerPanelStackView:     UIStackView!
    @IBOutlet weak var intensityStepper:        UIStepper!
    
    @IBAction func stopTraining(_ sender: UITapGestureRecognizer) {
        
        if !isOptionsMenuOpened { isStarted = false }
    }
    
    @IBAction func start() { isStarted = true }
    
    @IBAction func showIntro(_ sender: UIButton) {
        
        showIntroductionView()
    }
    
    @IBAction func intensityChanged(_ sender: UIStepper) {
        
        intensity = Int(sender.value)
    }
    
    @IBAction func optionsMenuButtonPressed(_ sender: UIButton) {
        
        isOptionsMenuOpened = !isOptionsMenuOpened
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeNotifications()
        loadValues() // Load saved training settings        
        setTrainingViews()
        setIntensityLabelText()
        
        optionsImageView.tag = imageTag
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
    
    private func subscribeNotifications() {
        
        //We will subscribe on messages from OptionsView
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: NotificationNames.newImageRequested.rawValue),
            object: nil,
            queue: OperationQueue.main) { _ in
                
                self.optionsImageView.image = self.optionsView.currentImage
        }
    }
    
    private func closeOptionsMenu() {
        trainingScreenModification()
    }
    
    private func openOptionsMenu() {
        trainingScreenModification()
    }
    
    // Function will modify main screen before menu was shown
    private func trainingScreenModification() {
        
        let animationTiming = 1.2
        let alphaValue: CGFloat = isOptionsMenuOpened ? 0 : 1
        
        UIView.animate(withDuration: animationTiming) { 
            self.controlPanelStackView.alpha  = alphaValue
            self.trainingFieldStackView.alpha = alphaValue
            self.startButton.alpha            = alphaValue
        }
        
        optionsView = isOptionsMenuOpened ? ((Bundle.main.loadNibNamed("OptionsView", owner: self, options: nil))![0] as! OptionsView) : nil
        
        guard optionsView != nil else {
            
            let imageToDelete = view.viewWithTag(imageTag)!
            
            UIView.animate(withDuration: animationTiming, animations: {
                imageToDelete.alpha     = 0
                imageToDelete.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                self.optionsMenu!.frame.origin.y -= self.optionsMenu!.frame.height
                self.optionsMenu!.alpha           = 0
                
            }, completion: { _ in
                self.optionsMenu!.removeFromSuperview()
                imageToDelete.removeFromSuperview()
            })
            
            return
        }
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: 500,
                           height: 250)
        
        optionsMenu = UIView(frame: frame)
        
        guard let optionsMenu = optionsMenu else { return }
        
        optionsMenu.backgroundColor  = UIColor(white: 0.7, alpha: 0.8)
        optionsMenu.center.x         = view.center.x
        optionsMenu.alpha            = 0
        optionsMenu.frame.origin.y   -= optionsMenu.frame.height
        optionsMenu.layer.cornerRadius = 10
        
        optionsView!.backgroundColor = .clear
        
        optionsMenu.addSubview(optionsView!)
        self.view.addSubview(optionsMenu)
        
        optionsImageView.alpha     = 0
        optionsImageView.frame     = CGRect(x: view.center.x - 45,
                                 y: 0,
                                 width: 90,
                                 height: 90)
        optionsImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        let valueY = view.bounds.height - 100
        
        optionsImageView.frame.origin.y = valueY
        optionsImageView.image          = optionsView.currentImage
        
        view.addSubview(optionsImageView)
        
        UIView.animate(withDuration: animationTiming, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: { 
            optionsMenu.frame.origin.y = -100
            optionsMenu.alpha          = 1.0
            self.optionsImageView.alpha                = 1.0
            self.optionsImageView.transform            = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }) { _ in }
    }
    
    private func makePurchase() {
        
        var prodIDs = Set<String>()
        
        prodIDs.insert(inAppID)
        
        let request = SKProductsRequest(productIdentifiers: prodIDs)
        
        request.delegate = self
        
        request.start()
    }
    
    private func showIntroductionView() {
        
        isIntroAppeared = true
        
        toggleHideAll()
        
        let controller = storyboard!.instantiateViewController(withIdentifier: .introductionVC) as! IntroductionViewController
        
        controller.trainingVC            = self
        controller.transitioningDelegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    //Triggered by bool property isStarted
    private func stopTraining() {
        
        leftImage.layer.removeAllAnimations()
        rightImage.layer.removeAllAnimations()
        
        trainingPreparationSpinner?.removeFromSuperlayer()
        
        toggleControlsHiding()
    }
    
    func toggleHideAll() {
       
        let value: CGFloat = isIntroAppeared ? 0 : 1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.infoButton.alpha              = value
            self.startButton.alpha             = value
            self.leftImage.alpha               = value
            self.rightImage.alpha              = value
            self.controlPanelStackView.alpha   = value
        })        
    }
    
    private func toggleControlsHiding() {
        
        let value: CGFloat = isStarted ? 0 : 1       
        
        UIView.animate(withDuration: 0.7) {
            self.infoButton.alpha               = value
            self.startButton.alpha              = value
            self.intensityPanelStackView.alpha  = value
            self.timerPanelStackView.alpha      = value
            self.controlPanelStackView.isHidden = value == 1 ? false : true
        }
    }
    
    //Triggered by bool property isStarted
    private func prepareForTraining() {
        
        saveValues()
        toggleControlsHiding()
        
        trainingPreparationSpinner = OvalShapeLayer(point: startButton.center)
        
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
    
    private func setTrainingViews() {
        
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
    }
}

extension TrainingViewController: CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        isStarted = false
    }
}

extension TrainingViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        animator.forDismissal = false
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        animator.forDismissal = true
        
        return animator
    }
}

extension TrainingViewController: SKProductsRequestDelegate
{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers
        let products = response.products
        
        print("a")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
    }
}



