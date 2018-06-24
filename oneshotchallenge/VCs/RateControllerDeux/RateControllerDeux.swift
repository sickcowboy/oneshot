//
//  RateControllerDeux.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-16.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RateControllerDeux: UIViewController, RateFrameImageViewDelegate {
    //MARK: - properties
    var isOnBoarding = false
    
    var onBoardingImages: [UIImage]? {
        didSet{
            
        }
    }
    
    let cetTime = CETTime()
    let fbRatings = FireBaseRating()
    
    var partisipants: [String]? {
        didSet {
            guard let partispants = partisipants else { return }
            fetchPosts(partisipants: partispants)
        }
    }
    
    var posts: [Post]? 
    
    var challenge: Challenge? {
        didSet{
            guard let challenge = challenge else { return }
            checkIfUserHasPosted(key: challenge.key)
            titleLabel.text = challenge.description
        }
    }
    
    var voteCount: Int? {
        didSet{
            guard let voteCount = voteCount else { return }
            voteCountLabel.countTo(number: 10 - voteCount)
            if voteCount == 10 {
                addPartisipant()
                return
            }
        }
    }
    
    //MARK: - views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.sharedInstance.primaryTextColor
        return label
    }()
    
    var voteCountLabel = CountLabel()
    
    var rateViewTop : RateFrameImageView?
    var rateViewBottom : RateFrameImageView?
    
    var imageStackView : UIStackView?
    var labelStackView : UIStackView?
    
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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        StausBar.sharedInstance.changeColor(view: view)
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Colors.sharedInstance.primaryColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lockedLabel.removeFromSuperview()
        imageStackView?.removeFromSuperview()
        labelStackView?.removeFromSuperview()
        
        if !isOnBoarding {
            fetchKey()
        } else {
            let onBoardingImagesStruct = OnBoardingImages()
            onBoardingImages = onBoardingImagesStruct.images
        }
    }
    
    //MARK: - Setup views
    func setUpVoteView() {
        labelStackView = UIStackView(arrangedSubviews: [titleLabel, voteCountLabel])
        labelStackView?.setUp(vertical: false, spacing: 8)
        
        guard let labelStackView = labelStackView else { return }
        view.addSubview(labelStackView)
        labelStackView.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, size: .init(width: 0, height: 44))
        
        rateViewTop = RateFrameImageView()
        rateViewBottom = RateFrameImageView()
        
        if !isOnBoarding {
            rateViewTop?.post = posts?.first
            posts?.removeFirst()
            rateViewBottom?.post = posts?.first
            posts?.removeFirst()
        } else {
            rateViewTop?.image = onBoardingImages?.first
            onBoardingImages?.removeFirst()
            rateViewBottom?.image = onBoardingImages?.first
            onBoardingImages?.removeFirst()
        }
        
        rateViewTop?.delegate = self
        rateViewBottom?.delegate = self
        
        rateViewTop?.positionIndex = 0
        rateViewBottom?.positionIndex = 1
        
        guard let rateViewTop = rateViewTop else { return }
        guard let rateViewBottom = rateViewBottom else { return }
        
        imageStackView = UIStackView(arrangedSubviews: [rateViewTop, rateViewBottom])
        imageStackView?.setUp(vertical: true, spacing: 4)
        
        guard let imageStackView = imageStackView else { return }
        view.addSubview(imageStackView)
        imageStackView.constraintLayout(top: labelStackView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func setUpLockedLabel(done: Bool) {
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
        refreshButton.removeFromSuperview()
        
        view.addSubview(refreshButton)
        refreshButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor)
        
        animateView(view: refreshButton)
    }
    
    //MARK: - Actions
    @objc func refresh() {
        fetchKey()
        
        refreshButton.removeFromSuperview()
    }
    
    //MARK: - Setters
    fileprivate func attTitle(text: String, bigText: String) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: text,
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        
        attributedTitle.append(NSAttributedString(string: "\n\(bigText)",
            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                         NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        return attributedTitle
    }
   
    //MARK: - Animations
    fileprivate func animateView(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
        }, completion: nil)
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
    
    //MARK: - Rate view delegate functions
    func didVote(sender: RateFrameImageView) {
        guard let senderId = sender.positionIndex else { return }
        
        if senderId == 0 {
            rateViewBottom?.animateDown()
        } else {
            rateViewTop?.animateDown()
        }
        
        if !isOnBoarding {
            guard let posts = posts else { return }
            
            //Vote block
            let post = sender.post
            let month = MonthKey.sharedInstance.monthKey(timeInterval: post?.challengeDate)
            FBVote.sharedInstance.vote(uid: post?.userId, id: challenge?.key, month: month)
            voteCount! += 1
            
            if posts.count >= 2 && voteCount! <= 8 {
                self.rateViewBottom?.post = self.posts?.first
                self.posts?.removeFirst()
                self.rateViewTop?.post = self.posts?.first
                self.posts?.removeFirst()
            } else {
                self.rateViewBottom?.post = nil
                self.rateViewTop?.post = nil
            }
        } else {
            guard let onBoardingImages = onBoardingImages else { return }
            if onBoardingImages.count >= 2 {
                self.rateViewTop?.image = self.onBoardingImages?.first
                self.onBoardingImages?.removeFirst()
                self.rateViewBottom?.image = self.onBoardingImages?.first
                self.onBoardingImages?.removeFirst()
            } else {
                self.rateViewTop?.image = nil
                self.rateViewBottom?.image = nil
            }
        }
    }
    
    //checks if both views are done fetching images
    var done = [Int?]()
    func doneWithDownLoad(sender: RateFrameImageView) {
        done.append(sender.positionIndex)

        if done.count == 2 {
            rateViewTop?.animateBack()
            rateViewBottom?.animateBack()
            done.removeAll()
        }
    }
    
    var doneWithNothing = [Int?]()
    func doneWithAnimationAndNothingToShow(sender: RateFrameImageView) {
        doneWithNothing.append(sender.positionIndex)
        
        if doneWithNothing.count == 2 {
            doneWithNothing.removeAll()
            if voteCount! == 10 {
                labelStackView?.removeFromSuperview()
                imageStackView?.removeFromSuperview()
                setUpLockedLabel(done: true)
                return
            }
            
            setUpRefresh()
        }
    }
}
