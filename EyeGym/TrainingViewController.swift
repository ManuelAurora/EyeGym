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
    
    private var isStarted = false {
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
        case 0: return 60.0
        case 1: return 90.0
        case 2: return 120.0
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
        
        let introController = storyboard!.instantiateViewController(withIdentifier: .introductionVC)
        
        present(introController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        leftImage.image           = UIImage(withAsset: .earth)
        rightImage.image          = UIImage(withAsset: .earth)
        backgroundImageView.image = UIImage(withAsset: .space)
        
        infoButton.tintColor             = view.tintColor
        timeIntervalSegControl.tintColor = view.tintColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        startButton.textForMask = "Start"
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let controller = storyboard!.instantiateViewController(withIdentifier: .introductionVC)
        
        present(controller, animated: true, completion: nil)
    }
    
    private func stopTraining() {
        
        leftImage.layer.removeAllAnimations()
        rightImage.layer.removeAllAnimations()
        
        traningPreparationSpinner?.removeFromSuperlayer()
        
        UIView.animate(withDuration: 0.7) {
            self.startButton.alpha            = 1
            self.timeIntervalSegControl.alpha = 1
        }
    }
    
    private func prepareForTraining() {
        
        let point = CGPoint(
            x: controlPanelStackView.bounds.width / 2,
            y: controlPanelStackView.bounds.height / 2)
        
        traningPreparationSpinner = OvalShapeLayer(point: point)
        
        UIView.animate(withDuration: 0.7) {
            self.startButton.alpha            = 0
            self.timeIntervalSegControl.alpha = 0
        }
        
        delay(seconds: 5) {
            guard self.isStarted else { return }
            
            self.leftImage.animate(with: self.requestedTimer, direction: .left, distance: self.maxDistance)
            self.rightImage.animate(with: self.requestedTimer, direction: .right, distance: self.maxDistance)
        }
    }
}





