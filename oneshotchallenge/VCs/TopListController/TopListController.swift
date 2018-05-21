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
    
    var todayScore: [TopListScore]?
    var monthScore: [TopListScore]?
    var allTimeScore: [TopListScore]?
    
    lazy var segmentedView : UISegmentedControl = {
        let sV = UISegmentedControl(items: ["Today", "Month", "All Time"])
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTopLists()
    }
    
    fileprivate func fetchTopLists() {
        let fbTopLists = FBTopLists()
        
        fbTopLists.fetchToday { (topList) in
            DispatchQueue.main.async {
                self.todayScore = topList
                self.collectionView?.reloadData()
            }
        }
        
        fbTopLists.fetchMonth { (topList) in
            DispatchQueue.main.async {
                self.monthScore = topList
            }
        }
        
        fbTopLists.fetchAllTime { (topList) in
            DispatchQueue.main.async {
                self.allTimeScore = topList
            }
        }
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
