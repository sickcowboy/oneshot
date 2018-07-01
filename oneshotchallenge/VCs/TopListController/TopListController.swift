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
    
    var todayScore: [TopListScore]? {
        didSet {
            debugPrint("today: \(todayScore?.count as Any)")
            stopRefresh()
        }
    }
    
    var monthScore: [TopListScore]? {
        didSet {
            debugPrint("month: \(monthScore?.count as Any)")
            stopRefresh()
        }
    }
    
    var allTimeScore: [TopListScore]? {
        didSet{
            debugPrint("allTime: \(allTimeScore?.count as Any)")
            stopRefresh()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Colors.sharedInstance.primaryTextColor
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refresher
    }()
    
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
        
        collectionView?.addSubview(refreshControl)
        
        (collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
        
        fetchTopLists()
    }
    
    @objc fileprivate func backFromBackground() {
        fetchTopLists()
    }
    
    fileprivate func fetchTopLists() {
        let fbTopLists = FBTopLists()
        
        todayScore = nil
        monthScore = nil
        allTimeScore = nil
        
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
    
    @objc func refresh() {
        fetchTopLists()
    }
    
    fileprivate func stopRefresh() {
        guard let todayScore = todayScore else { return }
        guard let monthScore = monthScore else { return }
        guard let allTimeScore = allTimeScore else { return }
        
        if !todayScore.isEmpty && !monthScore.isEmpty && !allTimeScore.isEmpty {
            refreshControl.endRefreshing()
        }
    }
}
