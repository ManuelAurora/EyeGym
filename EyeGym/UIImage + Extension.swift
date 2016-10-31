//
//  UIImage + Extension.swift
//  EyeGym
//
//  Created by Мануэль on 31.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

extension UIImage
{
    convenience init!(withAsset id: AssetID) {
        
        self.init(named: id.rawValue)
    }
}

