//
//  MainOnBoardingController.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-20.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class MainOnBoardingController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let welcomeController = OBWelcomeController()
        
        viewControllers = [welcomeController]
    }
}
