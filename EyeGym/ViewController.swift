//
//  ViewController.swift
//  EyeGym
//
//  Created by Мануэль on 07.02.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var _stack: UIStackView!
    
    @IBAction func _buttonTapped(sender: UIButton) {
       
        _stack.spacing = 300
        
        UIView.animateWithDuration(90, animations: {_ in
            self.view.layoutIfNeeded()
            }, completion: {_ in
                
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

