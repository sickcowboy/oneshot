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
    
    var initialFetch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(RateControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    fileprivate func fetchPosts() {
        let fbRatings = FireBaseRating()
        fbRatings.fetchPosts { (posts) in
            DispatchQueue.main.async {
                if let posts = posts {
                    self.posts = posts
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
        collectionView?.reloadData()
    }
}
