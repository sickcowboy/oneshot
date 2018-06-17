//
//  Colors.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class Colors {
    static let sharedInstance = Colors()
    
    let primaryColor = UIColor(displayP3Red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
    let secondaryColor = UIColor(displayP3Red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
    let lightColor = UIColor(displayP3Red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
    let darkColor = UIColor.black
    
    let primaryTextColor = UIColor.white
    
    let goldColor = UIColor(displayP3Red: 1, green: 0.84, blue: 0, alpha: 1)
    let silverColor = UIColor(displayP3Red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    let bronzeColor = UIColor(displayP3Red: 0.8, green: 0.5, blue: 0.2, alpha: 1)
    
    //MARK: - celebration colors
    let pinkColor = UIColor(displayP3Red: 0.69, green: 0, blue: 0.23, alpha: 1)
    let purpleColor = UIColor(displayP3Red: 0.2, green: 0.04, blue: 0.53, alpha: 1)
    let blueColor = UIColor(displayP3Red: 0, green: 0.16, blue: 0.52, alpha: 1)
    let greenColor = UIColor(displayP3Red: 0.03, green: 0.5, blue: 0.14, alpha: 1)
    lazy var celebrationColors = [pinkColor, purpleColor, blueColor, greenColor]
}
