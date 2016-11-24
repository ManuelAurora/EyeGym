//
//  TrainingObjectView.swift
//  EyeGym
//
//  Created by Мануэль on 27.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class TrainingObjectView: UIImageView {
    
    var animationDelegate: CAAnimationDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        
        layer.cornerRadius  = 30
        layer.masksToBounds = true
    }
    
    func animate(with time: Double, direction: Direction, distance: CGFloat) {
        
        let movePic          = CABasicAnimation(keyPath: "transform")
        let startedTransform = layer.transform
        let value: CGFloat   = direction == .left ? -distance : distance
        
        if let delegate = animationDelegate
        {
            movePic.delegate = delegate
        }
        
        movePic.fromValue = startedTransform
        movePic.toValue   = NSValue(caTransform3D: CATransform3DMakeTranslation(value, 0, 0))
        movePic.duration  = time        
        movePic.fillMode  = kCAFillModeForwards
        movePic.isRemovedOnCompletion = false
        
        layer.add(movePic, forKey: nil)
        
        layer.transform = startedTransform
    }
}

