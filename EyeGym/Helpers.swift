//
//  Helpers.swift
//  EyeGym
//
//  Created by Мануэль on 25.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

func delay(seconds: Double, completion: @escaping () -> ()) {
    
    let popTime =  DispatchTime.now() + seconds
    
    DispatchQueue.main.asyncAfter(deadline: popTime, execute: completion)    
}

enum ViewModelNotificationNames: String
{
    case lastIntroPageDidAppear
}

struct AnimationConstants
{    
    struct KeyPath
    {
        static let layer = "LayerToRemove"
    }
}

//View Controller Identififers
public enum StoryboardVCID: String
{
    case introductionVC
}

enum Direction
{
    case left
    case right
}

enum AssetID: String
{
    case earth
    case space
    case closeButton
}










    
