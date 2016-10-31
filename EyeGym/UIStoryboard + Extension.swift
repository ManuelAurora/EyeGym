//
//  UIStoryboard + Extension.swift
//  EyeGym
//
//  Created by Мануэль on 31.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

extension UIStoryboard
{
    open func instantiateViewController(withIdentifier identifier: StoryboardVCID) -> UIViewController {
        
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}

