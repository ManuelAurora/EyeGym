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
    
    var isStarted: Bool = false {
        didSet {
            toggleAnimations()
        }
    }
    
    let maxDistance: CGFloat = 200.0
    
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
   
    @IBOutlet weak var chooseTimeIntLabel:      UILabel!
    @IBOutlet weak var pressStartLabel:         UILabel!
    @IBOutlet weak var rotateNotificationLabel: UILabel!
    @IBOutlet weak var startButton:             StartButton!
    @IBOutlet weak var aboutButton:             UIButton!
    @IBOutlet weak var howToUseButton:          UIButton!
    @IBOutlet weak var timeIntervalSegControl:  UISegmentedControl!
    
    enum Direction
    {
        case left
        case right
    }
   
    @IBAction func start() {
        let timer = calculateTime(for: timeIntervalSegControl)
            
        animate(leftImage, with: timer, direction: .left)
        animate(rightImage, with: timer, direction: .right)
        
        isStarted = !isStarted
    }
       
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        startButton.textForMask = "Start"
       
    }
    
    func animate(_ image: UIImageView, with time: Double, direction: Direction) {
        
        let movePic          = CABasicAnimation(keyPath: "transform")
        let startedTransform = image.layer.transform
        
        let value: CGFloat = direction == .left ? -maxDistance : maxDistance
        
        movePic.fromValue = startedTransform
        movePic.toValue   = NSValue(caTransform3D: CATransform3DMakeTranslation(value, 0, 0))
        movePic.duration  = time
        
        image.layer.add(movePic, forKey: nil)
        
        image.layer.transform = startedTransform
    }
    
    func prepare(image view: UIImageView) {
        
        view.layer.cornerRadius  = 30
        view.layer.masksToBounds = true
    }
    
    func toggleAnimations() {
        
        if !isStarted
        {
            leftImage.layer.removeAllAnimations()
            rightImage.layer.removeAllAnimations()
        }
    }
    
    func calculateTime(for segmentedControl: UISegmentedControl) -> Double {
        
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
}



