//
//  TransitionAnimator.swift
//  EyeGym
//
//  Created by Мануэль on 15.12.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    let duration      = 1.0
    var forDismissal  = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let view      = forDismissal ? transitionContext.view(forKey: .from)! : transitionContext.view(forKey: .to)!
        
        let dimmingView = GradientView(frame: CGRect.zero)
        
        dimmingView.frame = container.bounds
        
        view.insertSubview(dimmingView, at: 0)
        
        view.alpha = forDismissal ? 1.0 : 0
        
        container.addSubview(view)
        
        UIView.animate(withDuration: duration, animations: { 
            view.alpha = self.forDismissal ? 0 : 1.0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
