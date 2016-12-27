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
        
        let previousPageData = introductionViewModel.previousPageData()
        
        changePageDataAnimated(previousPageData)
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        if canCloseIntroView
        {
            changeTrainingVCState(); dismiss(animated: true, completion: nil) // If this is a last page - dismiss VC
        }
        else
        {
            let nextPageData = introductionViewModel.nextPageData()
            
            // hides intro view before text and picture is changed
            changePageDataAnimated(nextPageData)
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
        
        modalPresentationStyle = .custom
    }
    
    private func configureIntroView() {
        
        nextButton.setTitle("Дальше", for: .normal)
        previousButton.setTitle("Назад", for: .normal)
        
        previousButton.alpha   = 0
        introductionView.alpha = 1.0
        
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
    
    private func changePageDataAnimated(_ page: (text: String?, image: UIImage?)) {
        
        let animDuration = 0.4
        
        UIView.animate(withDuration: animDuration, delay: 0, options: [], animations: {
            self.introductionView.imageView.alpha = 0
            self.introductionView.textLabel.alpha = 0
        }) { _ in
            self.introductionView.textLabel.text     = page.text
            self.introductionView.imageView.isHidden = page.image == nil ? true : false
            self.introductionView.imageView.image    = page.image
            
            UIView.animate(withDuration: animDuration, animations: { 
                self.introductionView.imageView.alpha = 1.0
                self.introductionView.textLabel.alpha = 1.0
            })
        }
    }
}

