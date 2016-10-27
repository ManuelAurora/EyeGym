//
//  StartButton.swift
//  EyeGym
//
//  Created by Мануэль on 21.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class StartButton: UIButton
{    
    var textForMask = "" {
        
        didSet
        {            
            layoutIfNeeded()
            layer.addSublayer(gradientLayer)
            makeGradientMaskViewWith(bounds: bounds)
        }
    }
    
    let gradientLayer: CAGradientLayer = {
        
        let layer = CAGradientLayer()
        
        let color = UIColor(colorLiteralRed: 255/255, green: 204/255, blue: 102/255, alpha: 1.0).cgColor
        
        let locations = [0.25, 0.50, 0.75]
        let colors    = [
            color,
            UIColor.white.cgColor,
            color
        ]
        
        
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint   = CGPoint(x: 1.0, y: 0.5)
        layer.colors     = colors
        layer.locations  = locations.map { NSNumber(value: $0) }
        
        return layer
    }()
    
    func makeGradientMaskViewWith(bounds: CGRect) {        
        
        gradientLayer.frame = bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        let textAttributes: [String: AnyObject] = {
            
            let style = NSMutableParagraphStyle()
            
            style.alignment = .center
            
            return [
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 28.0)!,
                NSParagraphStyleAttributeName: style
            ]
        }()
        
        textForMask.draw(in: bounds, withAttributes: textAttributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let maskLayer = CALayer()
        
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame           = bounds
        maskLayer.contents        = image?.cgImage
        
        gradientLayer.mask = maskLayer
        
        gradientLayer.add(createGradienAnimation(), forKey: nil)
    }
    
    private func createGradienAnimation() -> CABasicAnimation {
        
        let animate = CABasicAnimation(keyPath: "locations")
        
        animate.fromValue   = [0, 0, 0.25]
        animate.toValue     = [0.75, 1.0, 1.0]
        animate.duration    = 1.0
        animate.repeatCount = Float.infinity
        
        return animate
    }
    
}
