//
//  InformationClass.swift
//  EyeGym
//
//  Created by Мануэль on 11.02.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

struct Information {
    var _Images = [UIImage]()
    var _Text   = [String]()
    
    init(button: String) {
       _Images = chooseImages(button)
       _Text = chooseText(button)
    }
    
    func chooseImages(kind: String) -> [UIImage]{
        
        switch kind
        {
        case "about" : []
        case "info" : []
        default : break
        }
        
       return [UIImage(named: "circle")!]
    }
    
    func chooseText(kind: String) -> [String]{
        switch kind
        {
        case "about" : []
        case "info" : []
        default : break
        }
        
        return [""]
    }
    
    let aboutText = [""]
    let infoText = [""]
}
