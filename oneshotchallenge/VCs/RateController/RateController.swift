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
    
    var posts: [Post]? {
        didSet {
            guard let post = posts else { return }
            if post.count < 2 {
                posts?.removeAll()
            }
        }
    }
    
    var key = ""
    
    var initialFetch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StausBar.sharedInstance.changeColor(view: view)
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(RateControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? RateControllerCell {
                cell.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cell.imageView.alpha = 0
            }
        })
        
        initialFetch = true
        fetchPosts()
    }
    
    fileprivate func fetchPosts() {
        activityIndication(loading: true)
        
        let fbRatings = FireBaseRating()
        fbRatings.fetchPosts { (posts, key) in
            DispatchQueue.main.async {
                if let posts = posts, let key = key {
                    self.activityIndication(loading: false)
                    self.posts = posts
                    self.key = key
                    self.collectionView?.reloadData()
                    self.initialFetch = false
                } else {
                    self.activityIndication(loading: false)
                    // TODO : Something went wrong
                }
            }
        }
    }
    
    fileprivate let loadingScreen = LoadingScreen()
    
    fileprivate func activityIndication(loading: Bool) {
        if loading {
            view.addSubview(loadingScreen)
            loadingScreen.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            loadingScreen.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        posts = nil
        
        self.activityIndication(loading: false)
    }
}
