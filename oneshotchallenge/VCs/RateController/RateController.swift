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
    
    var partisipants: [String]? {
        didSet {
            posts = nil
            collectionView?.reloadData()
            
            guard let partispants = partisipants else { return }
            
            fetchPosts(partisipants: partispants)
        }
    }
    
    var posts: [Post]?
    
    var initialFetch = true
    
    var key: String? {
        didSet{
            guard let key = key else { return }
            checkIfDone(key: key)
        }
    }
    
    let lockedLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        let attributedTitle = NSMutableAttributedString(string: "No more votes until",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedTitle.append(NSAttributedString(string: "\nTOMORROW",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 44),
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
        
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? RateControllerCell {
                cell.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cell.imageView.alpha = 0
            }
        })
        
        initialFetch = true
        fetchKey()
    }
    
    fileprivate func setUpVotingDone() {
        view.addSubview(lockedLabel)
        lockedLabel.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor)
    }
    
    fileprivate let cetTime = CETTime()
    fileprivate let fbRatings = FireBaseRating()
    
    fileprivate func fetchKey() {
        let fbChallenges = FireBaseChallenges()
        
        fbChallenges.fetchChallenge(challengeDate: cetTime.debugTime()) { (challenge) in
            if let challenge = challenge {
                self.key = challenge.key
            }
        }
    }
    
    fileprivate func checkIfDone(key: String) {
        activityIndication(loading: true)
        fbRatings.checkIfVoteIsDone(key: key) { (done) in
            if let done = done {
                if done {
                    DispatchQueue.main.async {
                        self.activityIndication(loading: false)
                        self.setUpVotingDone()
                    }
                } else {
                    self.fetchPartisipants()
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndication(loading: false)
                }
                // TODO : Something went wrong
            }
        }
    }
    
    fileprivate func fetchPartisipants() {
        fbRatings.fetchPartisipants(key: key) { (partisipants) in
            DispatchQueue.main.async {
                self.activityIndication(loading: false)

                if let partisipants = partisipants {
                    self.partisipants = partisipants
                } else {
                    // TODO : Something went wrong
                }
            }
        }
    }
    
    fileprivate func fetchPosts(partisipants: [String]) {
        posts = [Post]()
        
        guard let timeInterval = cetTime.debugTime() else { return }
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let fbPosts = FireBasePosts()
        for partisipant in partisipants {
            fbPosts.fetchPost(uid: partisipant, date: date) { (post) in
                if let post = post {
                    self.posts?.append(post)
                    
                    if self.posts!.count == partisipants.count {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                            return
                        }
                    }
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
        partisipants = nil
        
        self.activityIndication(loading: false)
    }
}
