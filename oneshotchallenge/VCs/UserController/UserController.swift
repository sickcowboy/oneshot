//
//  UserController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        
        navigationController?.navigationBar.barTintColor = Colors.sharedInstance.darkColor
        navigationController?.navigationBar.tintColor = Colors.sharedInstance.darkColor
    }
}
