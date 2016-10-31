//
//  IntroductionViewController.swift
//  EyeGym
//
//  Created by Мануэль on 31.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController
{
    @IBOutlet weak var introductionView: UIView!
    
    @IBAction func next(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introductionView.alpha = 1.0
        introductionView.layer.cornerRadius = 10
        view.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transitioningDelegate  = self
        modalPresentationStyle = .custom
    }
    
}

extension IntroductionViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)        
    }
}
