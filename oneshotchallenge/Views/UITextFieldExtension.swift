//
//  UITextFieldExtension.swift
//  remotepush
//
//  Created by Dennis Galvén on 2018-03-01.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension UITextField {
    func setUp(placeholdertext: String) {
        placeholder = placeholdertext
        backgroundColor = Colors.sharedInstance.lightColor
        textColor = Colors.sharedInstance.primaryTextColor
        borderStyle = .roundedRect
        font = UIFont.systemFont(ofSize: 14)
    }
}
