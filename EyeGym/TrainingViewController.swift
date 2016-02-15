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
    
    @IBOutlet weak var _chooseTimeIntLabel     : UILabel!
    @IBOutlet weak var _pressStartLabel        : UILabel!
    @IBOutlet weak var _rotateNotificationLabel: UILabel!
    @IBOutlet weak var _startButton            : UIButton!
    @IBOutlet weak var _aboutButton            : UIButton!
    @IBOutlet weak var _howToUseButton         : UIButton!
    @IBOutlet weak var _timeIntervalSegControl : UISegmentedControl!
  
    var _leftCircle = UIImageView()
    var _rightCircle = UIImageView()
    var _trainingInProcess = false
    
    @IBAction func _buttonTapped(sender: UIButton) {
        
        if _trainingInProcess == false {
            
            var interval = NSTimeInterval()
            
            switch _timeIntervalSegControl.selectedSegmentIndex
            {
            case 0 : interval = 60
            case 1 : interval = 90
            case 2 : interval = 120
            default : break
            }
    
            performStretching(interval)
        }
        startStopTraining()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCircles()
        
        if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular {
            _leftCircle.hidden  = true
            _rightCircle.hidden = true
        }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
        let result = self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular
        
        _rotateNotificationLabel.hidden = !result
        _leftCircle.hidden   = result
        _rightCircle.hidden  = result
        _startButton.enabled = !result
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performStretching(timer: NSTimeInterval) {
       
        _leftCircle.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 30).active = true
        _rightCircle.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -30).active = true
       
        UIView.animateWithDuration(timer, animations: {_ in
            self.view.layoutIfNeeded()
           
            }, completion: {_ in
                self.removeCircles()
                self._trainingInProcess = false
                self.animateView()
        })
    }
    
    func startStopTraining() {
        
        if _trainingInProcess {
            view.layer.removeAllAnimations()
            removeCircles()
        }
        
        _trainingInProcess = !_trainingInProcess
        
        animateView()        
    }
    
    func createCircles() {
        view.layoutIfNeeded()
        let leftCircle = UIImageView()
        leftCircle.translatesAutoresizingMaskIntoConstraints = false
        leftCircle.image = UIImage(named: "earth2")
        view.addSubview(leftCircle)
        _leftCircle = leftCircle

        leftCircle.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 180).active = true
        leftCircle.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 60).active = true
        leftCircle.heightAnchor.constraintEqualToConstant(70).active = true
        leftCircle.widthAnchor.constraintEqualToConstant(70).active = true
        
        let rightCircle = UIImageView()
        rightCircle.translatesAutoresizingMaskIntoConstraints = false
        rightCircle.image = UIImage(named: "earth2")
        view.addSubview(rightCircle)
        _rightCircle = rightCircle
        
        rightCircle.trailingAnchor.constraintGreaterThanOrEqualToAnchor(view.trailingAnchor, constant: -180).active = true
        rightCircle.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 60).active = true
        rightCircle.heightAnchor.constraintEqualToConstant(70).active = true
        rightCircle.widthAnchor.constraintEqualToConstant(70).active = true
    }
    
    func removeCircles() {
        _leftCircle.removeFromSuperview()
        _rightCircle.removeFromSuperview()
    }
    
    func animateView() {
        UIView.animateWithDuration(0.67, animations: {_ in
            self.view.layoutIfNeeded()
            self._timeIntervalSegControl.hidden = self._trainingInProcess
            self._chooseTimeIntLabel.hidden     = self._trainingInProcess
            self._pressStartLabel.alpha = self._trainingInProcess ? 0.0 : 1.0
            self._aboutButton.alpha     = self._trainingInProcess ? 0.0 : 1.0
            self._howToUseButton.alpha  = self._trainingInProcess ? 0.0 : 1.0
            if self._trainingInProcess == false { self.createCircles() }
            }, completion: {_ in
               
        })
        
        _trainingInProcess == true ? _startButton.setTitle("Stop", forState: .Normal) : self._startButton.setTitle("Start", forState: .Normal)
    }
    
}

