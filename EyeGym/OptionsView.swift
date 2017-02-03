//
//  OptionsView.swift
//  EyeGym
//
//  Created by Мануэль on 19.01.17.
//  Copyright © 2017 AuroraInterplay. All rights reserved.
//

import UIKit

class OptionsView: UIView
{    
    var images = [#imageLiteral(resourceName: "earth"), #imageLiteral(resourceName: "mars"), #imageLiteral(resourceName: "mercury"), #imageLiteral(resourceName: "venus"), #imageLiteral(resourceName: "neptune"), #imageLiteral(resourceName: "jupiter"), #imageLiteral(resourceName: "uranus")]
    
    var currentImage: UIImage! {
        didSet {
            let imageChanged = Notification(name: .init(NotificationNames.newImageRequested.rawValue))
            
            NotificationCenter.default.post(imageChanged)
        }
    }
   
    private var currentImageIndex = 0
    
    @IBOutlet weak var changePlanetImageLabel:   UILabel!
    @IBOutlet weak var changeBackgroundLabel:    UILabel!
    @IBOutlet weak var toggleBackgroundLabel:    UILabel!
    @IBOutlet weak var togglePlanetImageLabel:   UILabel!
    @IBOutlet weak var changePlanetImageStepper: UIStepper!
    @IBOutlet weak var changeBackgroundStepper:  UIStepper!
    @IBOutlet weak var toggleBackgroundSwitch:   UISwitch!
    @IBOutlet weak var togglePlanetImageSwitch:  UISwitch!
    @IBOutlet weak var unlockButton:             UIButton!
    
    @IBAction func changeImage(_ sender: UIStepper) {
        
        if Int(changePlanetImageStepper.value) > images.count - 1
        {
            currentImageIndex = 0
            changePlanetImageStepper.value = 0
        }
        else if Int(changePlanetImageStepper.value) < 0
        {
            currentImageIndex = images.count - 1
            currentImage      = images[currentImageIndex]
            
            changePlanetImageStepper.value = Double(currentImageIndex)
        }
        else { currentImageIndex = Int(changePlanetImageStepper.value) }
        
        currentImage = images[currentImageIndex]
    }
    
    override func didMoveToSuperview() {
        
        changePlanetImageStepper.maximumValue = 999999
        changePlanetImageStepper.minimumValue = -10000
        changePlanetImageStepper.value        = Double(currentImageIndex)
        
        if currentImage == nil { currentImage = images[0] }
    }
    
}
