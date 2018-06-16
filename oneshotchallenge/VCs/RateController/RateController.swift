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
    let headerId = "headerId"
    let cetTime = CETTime()
    let fbRatings = FireBaseRating()
    
    var partisipants: [String]? {
        didSet {
            guard let partispants = partisipants else { return }
            debugPrint(partispants.count)
            fetchPosts(partisipants: partispants)
        }
    }
    
    var posts: [Post]? {
        didSet{
            debugPrint(posts?.count as Any)
        }
    }
    
    var challenge: Challenge? {
        didSet{
            guard let challenge = challenge else { return }
            checkIfUserHasPosted(key: challenge.key)
            navigationItem.title = challenge.description
        }
    }
    
    var voteCount: Int? {
        didSet{
            guard let voteCount = voteCount else { return }
            if voteCount == 10 {
                addPartisipant()
                setUpLockedLabel(done: true)
                return
            }
            
//            let indexPath = IndexPath(item: 0, section: 0)
//            if let header = collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: indexPath) as? RateControllerHeader {
////                header.numberOfVotes = voteCount
//            }
        }
    }
    
    let lockedLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.setImage(#imageLiteral(resourceName: "Refresh"), for: .normal)
        button.setTitle("No posts found. Refresh?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.alignTextBelow(spacing: 2)
        
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StausBar.sharedInstance.changeColor(view: view)
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(RateControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(RateControllerHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lockedLabel.removeFromSuperview()
        
        fetchKey()
    }
    
    func setUpLockedLabel(done: Bool) {        
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? RateControllerCell {
                cell.animateDown()
            }
        })
        
        if done {
            lockedLabel.attributedText = attTitle(text: "Voting", bigText: "COMPLETED")
        } else {
            lockedLabel.attributedText = attTitle(text: "You need to enter a challenge before", bigText: "VOTING")
        }
        
        view.addSubview(lockedLabel)
        lockedLabel.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor)
        
        animateView(view: lockedLabel)
    }
    
    func setUpRefresh() {
        collectionView?.visibleCells.forEach({ (cell) in
            if let cell = cell as? RateControllerCell {
                cell.animateDown()
            }
        })
        
        refreshButton.removeFromSuperview()
        
        view.addSubview(refreshButton)
        refreshButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor)
        
        animateView(view: refreshButton)
    }
    
    @objc func refresh() {
        fetchKey()
        
        refreshButton.removeFromSuperview()
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
    
    fileprivate func attTitle(text: String, bigText: String) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: text,
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        
        attributedTitle.append(NSAttributedString(string: "\n\(bigText)",
                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        return attributedTitle
    }
    
    fileprivate func animateView(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
        }, completion: nil)
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
