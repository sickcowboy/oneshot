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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(RateControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInsetAdjustmentBehavior = .never
        
        let fbRatings = FireBaseRating()
        fbRatings.fetchPosts { (posts) in
            DispatchQueue.main.async {
                if let posts = posts {
                    self.posts = posts
                    self.collectionView?.reloadData()
                } else {
                    // TODO : Something went wrong
                }
            }
        }
    }
}
