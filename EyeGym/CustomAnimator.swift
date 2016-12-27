//
//  CustomAnimator.swift
//  EyeGym
//
//  Created by Мануэль on 15.12.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning
{
    let duration = 1.0
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        containerView.addSubview(toView!)
        
        toView?.alpha = 0
        
        UIView.animate(withDuration: duration, animations: { 
            toView?.alpha = 1.0
            }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
}
