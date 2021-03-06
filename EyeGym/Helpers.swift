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

enum NotificationNames: String
{
    case pageNumberChanged
    case newImageRequested
}

struct AnimationConstants
{
    struct Keys
    {
        static let trainingAnimation = "TrainingAnimation"
    }
    
    struct KeyPath
    {
        static let layer = "LayerToRemove"
    }
}

//NSUserDefaults keys
enum UserDefaultsKeys: String
{
    case wasShown
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
    case mercury
    case space
    case closeButton
    case closeObjectLook
    case farObjectLook    
}










    
