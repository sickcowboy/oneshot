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
    let cetTime = CETTime()
    let fbRatings = FireBaseRating()
    
    var partisipants: [String]? {
        didSet {
            posts = nil
            collectionView?.reloadData()
            
            guard let partispants = partisipants else { return }
            
            fetchPosts(partisipants: partispants)
        }
    }
    
    var posts: [Post]? {
        didSet {
            guard let posts = posts else { return }
            
            if posts.isEmpty {
                debugPrint("No more posts")
            }
        }
    }
    
    var initialFetch = true
    
    var key: String? {
        didSet{
            guard let key = key else { return }
            checkIfUserHasPosted(key: key)
        }
    }
    
    var voteCount: UInt? {
        didSet{
            guard let voteCount = voteCount else { return }
            if voteCount == 10 {
                addPartisipant()
                setUpLockedLabel(done: true)
                return
            }
        }
    }
    
    let lockedLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        let attributedTitle = NSMutableAttributedString(string: "Voting complete for current",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        
        attributedTitle.append(NSAttributedString(string: "\nCHALLENGE",
                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        label.attributedText = attributedTitle
        
        return label
    }()
    
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
        
        lockedLabel.removeFromSuperview()
        
        initialFetch = true
        fetchKey()
    }
    
    func setUpLockedLabel(done: Bool) {
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? RateControllerCell {
                cell.animateDown()
            }
        })
        
        if done {
            lockedLabel.attributedText = attTitle(text: "Voting complete for current")
        } else {
            lockedLabel.attributedText = attTitle(text: "No post for current")
        }
        
        view.addSubview(lockedLabel)
        lockedLabel.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor)
    }

    fileprivate let loadingScreen = LoadingScreen()
    
    func activityIndication(loading: Bool) {
        if loading {
            view.addSubview(loadingScreen)
            loadingScreen.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            loadingScreen.removeFromSuperview()
        }
    }
    
    fileprivate func attTitle(text: String) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: text,
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        
        attributedTitle.append(NSAttributedString(string: "\nCHALLENGE",
                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        return attributedTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? RateControllerCell {
                cell.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cell.imageView.alpha = 0
            }
        })
        
        partisipants = nil
        
        self.activityIndication(loading: false)
    }
}
