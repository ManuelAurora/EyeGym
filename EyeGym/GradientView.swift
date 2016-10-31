//
//  GradientView.swift
//  EyeGym
//
//  Created by Мануэль on 31.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class GradientView: UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clear
    }
  
    override func draw(_ rect: CGRect) {
        
        let components: [CGFloat] = [0, 0, 0, 0.3, 0, 0, 0, 0.8]
        let locations:  [CGFloat] = [0, 1]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)
        
        let context = UIGraphicsGetCurrentContext()
        
        let centerX = bounds.midX
        let centerY = bounds.midY
        
        let centerPoint = CGPoint(x: centerX, y: centerY)
        
        let radius = max(centerX, centerY)
        
        context?.drawRadialGradient(gradient!, startCenter: centerPoint,
                                    startRadius: 0,
                                    endCenter: centerPoint,
                                    endRadius: radius,
                                    options: .drawsAfterEndLocation)
        
    }
    
}
