//
//  OvalShapeLayer.swift
//  EyeGym
//
//  Created by Мануэль on 27.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class OvalShapeLayer: CAShapeLayer
{
    
    private let radius: CGFloat = 40
    
    init(point: CGPoint) {
        super.init()
        
        let color = UIColor(colorLiteralRed: 255/255, green: 204/255, blue: 102/255, alpha: 1.0).cgColor
        
        strokeColor     = color
        fillColor       = UIColor.clear.cgColor
        lineDashPattern = [4, 3]
        lineWidth       = 6
        
        path = UIBezierPath(
            ovalIn: CGRect(
                x: point.x - radius,
                y: point.y - radius,
                width: radius * 2,
                height: radius * 2)
            ).cgPath
        
        addPrepareForTrainingAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addPrepareForTrainingAnimations() {
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue   = 1.0
        strokeStartAnimation.fillMode  = kCAFillModeForwards
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue   = 1.0
        strokeEndAnimation.fillMode  = kCAFillModeForwards
        
        let animationGroup = CAAnimationGroup()
        
        animationGroup.duration    = 1
        animationGroup.repeatCount = 5
        animationGroup.animations  = [strokeStartAnimation, strokeEndAnimation]
        
        animationGroup.setValue(self, forKeyPath: AnimationConstants.KeyPath.layer)
        
        animationGroup.delegate = self
        
        self.add(animationGroup, forKey: nil)
    }
    
    deinit {
        print("DEBUG: DEINIT")
    }
}

extension OvalShapeLayer: CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey: AnimationConstants.KeyPath.layer) as? CAShapeLayer
        {
            layer.removeFromSuperlayer()
        }
    }
}
