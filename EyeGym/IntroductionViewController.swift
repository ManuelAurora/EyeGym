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
    
    @IBAction func next(_ sender: UIButton) {
        
        if canCloseIntroView
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            introductionView.textView.text = introductionViewModel.nextPageText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
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
        introductionView.textView.text      = introductionViewModel.firstPageText()
    }
    
    private func subscribeNotifications() {
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: ViewModelNotificationNames.lastIntroPageDidAppear.rawValue),
            object: nil,
            queue: nil) { _ in
                self.nextButton.setTitle("Close", for: .normal)
                self.canCloseIntroView = true
        }
    }
}

extension IntroductionViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)        
    }
}
