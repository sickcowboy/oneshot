//
//  UIAlertControllerExtension.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension UIAlertController {
    func oneAction() {
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil )
        
        addAction(action)
    }
}
