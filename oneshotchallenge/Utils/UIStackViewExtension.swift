//
//  UIStackViewExtension.swift
//  Listor
//
//  Created by Dennis Galvén on 2018-03-27.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension UIStackView {
    func setUp(vertical: Bool, spacing: CGFloat, fill: Bool = false) {
        if vertical {
            self.axis = .vertical
        } else {
            self.axis = .horizontal
        }
        
        if fill {
            self.distribution = .fill
        } else {
            self.distribution = .fillEqually
        }
        
        self.spacing = spacing
    }
}
