//
//  DetailPostController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class DetailPostController: UIViewController {
    var post: Post? {
        didSet{
            frameView.photoImageView.loadImage(urlString: post?.imageUrl)
            setDateLabelText()
            
            fetchChallengeTitle()
        }
    }
    
    var challenge: Challenge? {
        didSet{
            guard let challenge = challenge else { return }
            self.challengeLabel.text = challenge.description
            
            fetchVotes(key: challenge.key)
        }
    }
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.darkColor
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let frameView = FramedPhotoView()
    
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Colors.sharedInstance.darkColor
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let votesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Colors.sharedInstance.darkColor
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.lightColor
    }
    
    fileprivate func setUp() {
        view.addSubview(frameView)
        frameView.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                   size: .init(width: view.frame.width - 50, height: view.frame.width - 50))
        
        view.addSubview(challengeLabel)
        challengeLabel.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: frameView.topAnchor, padding: .init(top: 0, left: 8, bottom: 4, right: 8))
        
        view.addSubview(dateLabel)
        dateLabel.constraintLayout(top: frameView.bottomAnchor, leading: frameView.leadingAnchor, trailing: frameView.trailingAnchor, bottom: nil, padding: .init(top: 4, left: 4, bottom: 0, right: 4))
        
        view.addSubview(votesLabel)
        votesLabel.constraintLayout(top: dateLabel.bottomAnchor, leading: frameView.leadingAnchor, trailing: frameView.trailingAnchor, bottom: nil, padding: .init(top: 4, left: 4, bottom: 0, right: 4))
    }
    
    fileprivate func setDateLabelText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        guard let timeInterval = post?.date else { return }
        let date = Date(timeIntervalSince1970: timeInterval)
        
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    fileprivate func fetchChallengeTitle() {
        guard let challengeDate = post?.challengeDate else { return }
        
        let fbChallenges = FireBaseChallenges()
        fbChallenges.fetchChallenge(challengeDate: challengeDate) { (challenge) in
            DispatchQueue.main.async {
                self.challenge = challenge
            }
        }
    }
    
    fileprivate func fetchVotes(key: String) {
        let fbVotes = FBVote()
        
        fbVotes.fetchNumberOfVotes(key: key, uid: post?.userId) { (votes) in
            DispatchQueue.main.async {
                self.setVoteLabelText(votes: votes)
                
                self.setUp()
            }
        }
    }
    
    fileprivate func setVoteLabelText(votes: Int?) {
        if votes == nil {
            votesLabel.text = "0 votes"
            return
        }
        
        let voteString = String(votes!)
        
        if votes == 1 {
            votesLabel.text = "\(voteString) vote"
            return
        }
        
        votesLabel.text = "\(voteString) votes"
    }
}
