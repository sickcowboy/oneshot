//
//  RateControllerCollectionViewFunctions.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-04-27.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension RateController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RateControllerCell
        
        cell.imageView.backgroundColor = .lightGray
        cell.imageView.image = stockImages[randomImage()]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tabHeight = tabBarController?.tabBar.frame.height
        let size = (collectionView.frame.height - tabHeight!) / 2
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
}
