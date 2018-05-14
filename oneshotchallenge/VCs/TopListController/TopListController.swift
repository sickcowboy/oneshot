//
//  TopListController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class TopListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    lazy var segmentedView : UISegmentedControl = {
        let sV = UISegmentedControl(items: ["Today", "Monthly", "Yearly"])
        sV.tintColor = Colors.sharedInstance.primaryTextColor
        sV.selectedSegmentIndex = 0
        sV.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return sV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = segmentedView
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        
        collectionView?.register(TopListControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(TopListControllerHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerId)
        
        (collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
    }
    
    @objc fileprivate func segmentChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.collectionView?.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }) { (_) in
            
            self.collectionView?.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.collectionView?.reloadData()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.collectionView?.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        }
    }
}
