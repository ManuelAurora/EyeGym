//
//  DimmingPresentationController.swift
//  EyeGym
//
//  Created by Мануэль on 31.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController
{
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView else { return }
        
        dimmingView.alpha = 0
        dimmingView.frame = containerView.bounds
        
        containerView.insertSubview(dimmingView, at: 0)
        
        animateTransition(isDismissal: false)
    }
    
    override func dismissalTransitionWillBegin() {
        animateTransition(isDismissal: true)
    }
    
    private func animateTransition(isDismissal: Bool) {
        
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { _ in
                
                if isDismissal { self.dimmingView.alpha = 0.0 }
                else           { self.dimmingView.alpha = 1.0 }
                
                }, completion: nil)
        }
    }
}
