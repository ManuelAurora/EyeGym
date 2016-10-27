//
//  Helpers.swift
//  EyeGym
//
//  Created by Мануэль on 25.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation


func delay(seconds: Double, completion: @escaping () -> ()) {
    
    let popTime =  DispatchTime.now() + seconds
    
    DispatchQueue.main.asyncAfter(deadline: popTime, execute: completion)
    
}

struct AnimationConstants
{    
    struct KeyPath
    {
        static let layer = "LayerToRemove"
    }
}

enum Direction
{
    case left
    case right
}
