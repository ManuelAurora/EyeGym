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
    
    var trainingVC: TrainingViewController!
    
    @IBOutlet weak var closeButton:      UIButton!
    @IBOutlet weak var nextButton:       UIButton!
    @IBOutlet weak var previousButton:   UIButton!
    @IBOutlet weak var introductionView: IntroductionView!
    
    @IBAction func closeIntroView(_ sender: UIButton) {  changeTrainingVCState(); dismiss(animated: true, completion: nil) }
    
    @IBAction func previous(_ sender: UIButton) {
        
        animateTransition()
        
        let previousPageData = introductionViewModel.previousPageData()
        
        introductionView.textLabel.text  = previousPageData.text
        introductionView.imageView.image = previousPageData.image
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        if canCloseIntroView
        {
            changeTrainingVCState(); dismiss(animated: true, completion: nil) // If this is a last page - dismiss VC
        }
        else
        {
            // hides intro view before text and picture is changed
            animateTransition()
            
            let nextPageData = introductionViewModel.nextPageData()
            
            introductionView.textLabel.text  = nextPageData.text
            introductionView.imageView.image = nextPageData.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear    
        
        configureIntroView()
        subscribeNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transitioningDelegate  = self
        modalPresentationStyle = .custom
    }
    
    private func configureIntroView() {
        
        nextButton.setTitle("Дальше", for: .normal)
        previousButton.setTitle("Назад", for: .normal)
        
        previousButton.alpha                = 0
        introductionView.alpha              = 1.0
        introductionView.layer.cornerRadius = 10
        closeButton.layer.cornerRadius      = closeButton.imageView!.image!.size.width / 2
        
        let firstPageData = introductionViewModel.firstPageData()
        
        introductionView.textLabel.text  = firstPageData.text
        introductionView.imageView.image = firstPageData.image
    }
    
    private func changeTrainingVCState() {
        trainingVC.isIntroAppeared = false
        trainingVC.toggleHideAll()
    }
    
    private func subscribeNotifications() {
        
        //if intro view has reached last page - we can close window
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: ViewModelNotificationNames.pageNumberChanged.rawValue),
            object: nil,
            queue: nil) { _ in
                
                //This code will allow user to close intro view if last page reached.
                if self.introductionViewModel.pagesCount() == self.introductionViewModel.currentPageNumber()
                {
                    self.nextButton.setTitle("Закрыть", for: .normal)
                    self.canCloseIntroView = true
                }
                else
                {
                    self.nextButton.setTitle("Дальше", for: .normal)
                    self.canCloseIntroView = false
                }
                
                //Hides prev. button on the first page.
                self.previousButton.alpha = self.introductionViewModel.currentPageNumber() > 1 ? 1.0 : 0
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
