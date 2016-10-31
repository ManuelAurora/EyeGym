//
//  Protocols.swift
//  EyeGym
//
//  Created by Мануэль on 31.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

protocol SegueHandlerType
{
    associatedtype SegueID: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueID.RawValue == String
{
    func performSegue(withIdentifier identifier: SegueID, sender: AnyObject?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueID {
        
        guard let identifier = segue.identifier, let segueIdentifier = SegueID(rawValue: identifier) else {
            fatalError("invalid segue identifier \(segue.identifier)")
        }
        
        return segueIdentifier
    }
}
