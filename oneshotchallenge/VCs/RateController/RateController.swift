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
        initialFetch = true
        fetchPosts()
    }
    
    fileprivate func fetchPosts() {
        let fbRatings = FireBaseRating()
        fbRatings.fetchPosts { (posts, key) in
            DispatchQueue.main.async {
                if let posts = posts, let key = key {
                    self.posts = posts
                    self.key = key
                    self.collectionView?.reloadData()
                    self.initialFetch = false
                } else {
                    // TODO : Something went wrong
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        posts = nil
    }
}
