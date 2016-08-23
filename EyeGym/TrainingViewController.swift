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
    
    @IBOutlet weak var rightImage:              UIImageView!
    @IBOutlet weak var leftImage:               UIImageView!
    @IBOutlet weak var chooseTimeIntLabel:      UILabel!
    @IBOutlet weak var pressStartLabel:         UILabel!
    @IBOutlet weak var rotateNotificationLabel: UILabel!
    @IBOutlet weak var startButton:             UIButton!
    @IBOutlet weak var aboutButton:             UIButton!
    @IBOutlet weak var howToUseButton:          UIButton!
    @IBOutlet weak var timeIntervalSegControl:  UISegmentedControl!
    
    enum Direction
    {
        case Left
        case Right
    }
    
    var started: Bool = false
    
    @IBAction func start() {
        
        
        
        animateImage(leftImage, time: Double(60), direction: .Left)
        animateImage(rightImage, time: Double(60), direction: .Right)
        
        started = true
    }
    
    func animateImage(image: UIImageView, time: Double, direction: Direction) {
        
        let leftOriginalCenter  = leftImage.center
        let rightOriginalCenter = rightImage.center
      
        let movePic = CABasicAnimation(keyPath: "position.x")
        
        movePic.fromValue = direction == .Left ? leftOriginalCenter.x : rightOriginalCenter.x
        movePic.toValue   = direction == .Left ? (0 + image.frame.width / 2) : (view!.bounds.width - image.frame.width / 2)
        movePic.duration  = Double(time)
        //movePic.fillMode  = kCAFillModeBoth
        
        //movePic.removedOnCompletion = false
        
        image.layer.addAnimation(movePic, forKey: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftImage.layer.cornerRadius   = 30
        rightImage.layer.cornerRadius  = 30
        
        leftImage.layer.masksToBounds  = true
        rightImage.layer.masksToBounds = true
        
        }
    
    
}



