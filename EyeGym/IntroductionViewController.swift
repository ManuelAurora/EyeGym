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
    private let introductionViewModel = IntroductionPageViewModel()
    
    private var canCloseIntroView: Bool = false
    
    @IBOutlet weak var nextButton:       UIButton!
    @IBOutlet weak var introductionView: IntroductionView!
    
    @IBAction func closeIntroView(_ sender: UIButton) {  dismiss(animated: true, completion: nil) }
    
    @IBAction func next(_ sender: UIButton) {
        
        if canCloseIntroView
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            animateTransition() // hides intro view before text and picture is changed
            
            let nextPageData = introductionViewModel.nextPageData()
            
            introductionView.textView.text   = nextPageData.text
            introductionView.imageView.image = nextPageData.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        nextButton.tintColor = .black
        
        configureIntroView()
        subscribeNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transitioningDelegate  = self
        modalPresentationStyle = .custom
    }
    
    private func configureIntroView() {
        
        introductionView.alpha              = 1.0
        introductionView.layer.cornerRadius = 10
        
        let firstPageData = introductionViewModel.firstPageData()
        
        introductionView.textView.text      = firstPageData.text
        introductionView.imageView.image    = firstPageData.image
    }
    
    private func subscribeNotifications() {
        
        //if intro view has reached last page - we can close window
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: ViewModelNotificationNames.lastIntroPageDidAppear.rawValue),
            object: nil,
            queue: nil) { _ in
                self.nextButton.setTitle("Close", for: .normal)
                self.canCloseIntroView = true
        }
    }
    
    private func animateTransition() {
        
        UIView.transition(with: introductionView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            
                self.introductionView.isHidden = true
        }) { _ in
            
            UIView.transition(with: self.introductionView,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                
                self.introductionView.isHidden = false
                }, completion: nil)
        }
    }
}

extension IntroductionViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)        
    }
}
