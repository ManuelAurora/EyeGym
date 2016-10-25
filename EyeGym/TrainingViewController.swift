//
//  ViewController.swift
//  EyeGym
//
//  Created by Мануэль on 07.02.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit


class TrainingViewController: UIViewController
{
    fileprivate var ovalShapeLayer: CAShapeLayer {
        
        let ovalShapeLayer = CAShapeLayer()
        
            let radius: CGFloat = 40
            
            ovalShapeLayer.strokeColor     = UIColor.orange.cgColor
            ovalShapeLayer.fillColor       = UIColor.clear.cgColor
            ovalShapeLayer.lineDashPattern = [2, 3]
            ovalShapeLayer.lineWidth       = 4
            
            ovalShapeLayer.path = UIBezierPath(
                ovalIn: CGRect(
                    x: controlPanelStackView.bounds.width / 2 - radius,
                    y: controlPanelStackView.bounds.height / 2 - radius,
                    width: radius * 2,
                    height: radius * 2)
                ).cgPath
        
        addPrepareForTrainingAnimations(to: ovalShapeLayer)
        
        return ovalShapeLayer
    }
    
    fileprivate var layersToRemoveArray = [CALayer]()
    
    private var isStarted: Bool = false {
        didSet
        {
            toggleAnimations()
            
            if isStarted { prepareForTraining() }
        }
    }
    
    private let maxDistance: CGFloat = 150.0
    
    @IBOutlet weak var rightImage: UIImageView! {
        didSet {
            prepare(image: rightImage)
        }
    }
    @IBOutlet weak var leftImage: UIImageView! {
        didSet {
            prepare(image: leftImage)
        }
    }
   
    @IBOutlet weak var controlPanelStackView: UIStackView!
    @IBOutlet weak var chooseTimeIntLabel:      UILabel!
    @IBOutlet weak var pressStartLabel:         UILabel!
    @IBOutlet weak var rotateNotificationLabel: UILabel!
    @IBOutlet weak var startButton:             StartButton!
    @IBOutlet weak var aboutButton:             UIButton!
    @IBOutlet weak var howToUseButton:          UIButton!
    @IBOutlet weak var timeIntervalSegControl:  UISegmentedControl!
    
    private enum Direction
    {
        case left
        case right
    }
   
    @IBAction func stopTraining(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func start() {
        
        let trainingTime = calculateTime(for: timeIntervalSegControl)
        
        delay(seconds: 5) {
            
            self.animate(self.leftImage, with: trainingTime, direction: .left)
            self.animate(self.rightImage, with: trainingTime, direction: .right)
        }
        
        isStarted = !isStarted
    }
       
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        startButton.textForMask = "Start"
    }
    
    private func animate(_ image: UIImageView, with time: Double, direction: Direction) {
        
        let movePic          = CABasicAnimation(keyPath: "transform")
        let startedTransform = image.layer.transform
        
        let value: CGFloat = direction == .left ? -maxDistance : maxDistance
        
        movePic.fromValue = startedTransform
        movePic.toValue   = NSValue(caTransform3D: CATransform3DMakeTranslation(value, 0, 0))
        movePic.duration  = time
        
        image.layer.add(movePic, forKey: nil)
        
        image.layer.transform = startedTransform
    }
    
    private func prepare(image view: UIImageView) {
        
        view.layer.cornerRadius  = 30
        view.layer.masksToBounds = true
    }
    
    private func toggleAnimations() {
        
        if !isStarted
        {
            leftImage.layer.removeAllAnimations()
            rightImage.layer.removeAllAnimations()
        }
    }
    
    private func prepareForTraining() {
        
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            
            self.timeIntervalSegControl.alpha = 0
            self.startButton.alpha            = 0
            
            }, completion: nil)
        
        controlPanelStackView.layer.addSublayer(ovalShapeLayer)
    }
    
    private func calculateTime(for segmentedControl: UISegmentedControl) -> Double {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            return 60.0
        case 1:
            return 90.0
        case 2:
            return 120.0
        default:
            return 60.0
        }
    }
    
    private func addPrepareForTrainingAnimations(to layer: CALayer) {
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue   = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue   = 1.0
        
        let animationGroup = CAAnimationGroup()
        
        animationGroup.duration    = 1
        animationGroup.repeatCount = 5
        animationGroup.animations  = [strokeStartAnimation, strokeEndAnimation]
        animationGroup.delegate    = self
        
        animationGroup.setValue(layer, forKeyPath: AnimationConstants.KeyPath.layer)
        
        layer.add(animationGroup, forKey: AnimationConstants.AnimKey.prepareForTraning)
        
        layersToRemoveArray.append(layer)
    }
}

extension TrainingViewController: CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if let layer = anim.value(forKeyPath: AnimationConstants.KeyPath.layer) as? CALayer {
            
            if layersToRemoveArray.contains(layer) { layer.removeFromSuperlayer() }
        }
        
    }
    
}


