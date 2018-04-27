//
//  RateController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RateController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let imageArray : [UIImage] = {
       var iva = [UIImage]()
        iva.append(#imageLiteral(resourceName: "FlashAuto"))
        iva.append(#imageLiteral(resourceName: "FlashOn"))
        iva.append(#imageLiteral(resourceName: "FlashOff"))
        iva.append(#imageLiteral(resourceName: "ForwardArrow"))
        iva.append(#imageLiteral(resourceName: "BackArrrow"))
        return iva
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.constraintLayout(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(RateControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInsetAdjustmentBehavior = .never
    }
    
    func randomNR () -> Int {
        
        let nr = arc4random_uniform(5)
         let intNr = Int(nr)
        
        return intNr
    }
}
