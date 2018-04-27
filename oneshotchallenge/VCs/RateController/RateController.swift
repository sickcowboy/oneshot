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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.constraintLayout(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        collectionView?.backgroundColor = Colors.sharedInstance.lightColor
        collectionView?.register(RateControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInsetAdjustmentBehavior = .never
    }
    
    func generateRandomImage () -> UIImage {
        
        let stockImages = [#imageLiteral(resourceName: "StockImage1"),#imageLiteral(resourceName: "StockImage2"),#imageLiteral(resourceName: "StockImage3"),#imageLiteral(resourceName: "StockImage4"),#imageLiteral(resourceName: "StockImage5"),#imageLiteral(resourceName: "StockImage6"),#imageLiteral(resourceName: "StockImage7"),#imageLiteral(resourceName: "StockImage8"),#imageLiteral(resourceName: "StockImage9"),#imageLiteral(resourceName: "StockImage10"),#imageLiteral(resourceName: "StockImage11"),#imageLiteral(resourceName: "StockImage12"),#imageLiteral(resourceName: "StockImage13"),#imageLiteral(resourceName: "StockImage14")]
        let nr = arc4random_uniform(14)
         let intNr = Int(nr)
        let pickedImage = stockImages[intNr]
        
        return pickedImage
    }
}
