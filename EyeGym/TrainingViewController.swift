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
    
    @IBOutlet weak var rightImage:              UIImageView! {
        didSet {
            prepare(image: rightImage)
        }
    }
    @IBOutlet weak var leftImage:               UIImageView! {
        didSet {
            prepare(image: leftImage)
        }
    }
    @IBOutlet weak var chooseTimeIntLabel:      UILabel!
    @IBOutlet weak var pressStartLabel:         UILabel!
    @IBOutlet weak var rotateNotificationLabel: UILabel!
    @IBOutlet weak var startButton:             UIButton!
    @IBOutlet weak var aboutButton:             UIButton!
    @IBOutlet weak var howToUseButton:          UIButton!
    @IBOutlet weak var timeIntervalSegControl:  UISegmentedControl!
    
    enum Direction
    {
        case left
        case right
    }
    
    var isStarted = false {
        didSet {
            toggleButtonTitle()
            toggleAnimations()
        }
    }
    
    @IBAction func start() {
        let timer = calculateTime(for: timeIntervalSegControl)
            
        animate(leftImage, with: timer, direction: .left)
        animate(rightImage, with: timer, direction: .right)
        
        isStarted = !isStarted
    }
    
    func animate(_ image: UIImageView, with time: Double, direction: Direction) {
        
        let leftOriginalCenter  = leftImage.center
        let rightOriginalCenter = rightImage.center
      
        let movePic = CABasicAnimation(keyPath: "position.x")
        
        movePic.fromValue = direction == .left ? leftOriginalCenter.x : rightOriginalCenter.x
        movePic.toValue   = direction == .left ? (image.frame.width / 2) : (view!.bounds.width - image.frame.width / 2)
        movePic.duration  = time
        
        image.layer.add(movePic, forKey: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func prepare(image view: UIImageView) {
        
        view.layer.cornerRadius  = 30
        view.layer.masksToBounds = true
    }
    
    func toggleButtonTitle() {
        
        let title =  isStarted ? "Stop" : "Start"

        startButton.setTitle(title, for: .normal)
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



