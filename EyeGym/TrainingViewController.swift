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
    
    @IBOutlet weak var _stack: UIStackView!
    @IBOutlet weak var _startButton: UIButton!
    @IBOutlet weak var _timeIntervalSegControl: UISegmentedControl!
    @IBOutlet weak var _chooseTimeIntLabel: UILabel!
    @IBOutlet weak var _pressStartLabel: UILabel!
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func performStretching(timer: NSTimeInterval) {
        
        _stack.spacing = 350
        
        UIView.animateWithDuration(timer, animations: {_ in
            self.view.layoutIfNeeded()
        })
    }
    
    func startStopTraining() {
        _trainingInProcess = !_trainingInProcess
        
        UIView.animateWithDuration(1.0, animations: {_ in
            self._timeIntervalSegControl.hidden = self._trainingInProcess
            self._chooseTimeIntLabel.hidden = self._trainingInProcess
            self._pressStartLabel.hidden = self._trainingInProcess
            self._trainingInProcess == true ? self._startButton.setTitle("Stop", forState: .Normal) : self._startButton.setTitle("Start", forState: .Normal)
        })
        
        if _trainingInProcess {
            
        }
        
    }
    
}

