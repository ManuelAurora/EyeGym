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
    private let maxDistance: CGFloat = 150
    
    var requestedTimer: Double {
        
        switch timeIntervalSegControl.selectedSegmentIndex
        {
        case 0: return 60.0
        case 1: return 90.0
        case 2: return 120.0
        default: return 60.0
        }
    }
    
    @IBOutlet weak var rightImage:             TrainingObjectView!
    @IBOutlet weak var leftImage:              TrainingObjectView!
    @IBOutlet weak var startButton:            StartButton!
    @IBOutlet weak var controlPanelStackView:  UIStackView!
    @IBOutlet weak var timeIntervalSegControl: UISegmentedControl!
    
    @IBAction func stopTraining(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func start() {
        
        prepareForTraining()
    }
       
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        startButton.textForMask = "Start"
    }
    
    private func prepareForTraining() {
        
        let point = CGPoint(
            x: controlPanelStackView.bounds.width / 2,
            y: controlPanelStackView.bounds.height / 2)
        
        controlPanelStackView.layer.addSublayer(OvalShapeLayer(point: point))
        
        UIView.animate(withDuration: 0.7) {
            self.startButton.alpha            = 0
            self.timeIntervalSegControl.alpha = 0
        }
        
        delay(seconds: 5) {
            self.leftImage.animate(with: self.requestedTimer, direction: .left, distance: self.maxDistance)
            self.rightImage.animate(with: self.requestedTimer, direction: .right, distance: self.maxDistance)
        }
    }
}





