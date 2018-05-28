//
//  CalendarCell.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    var date: Date? {
        didSet{
            userImageView.image = nil
            goldImage.image = nil
            silverImage.image = nil
            bronzeImage.image = nil
            challengeLabel.text = nil
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            guard let date = date else { return }
            dateLabel.text = dateFormatter.string(from: date)
            
            let today = Date()
            if today.timeIntervalSince1970 < date.timeIntervalSince1970 {
                dateLabel.textColor = Colors.sharedInstance.secondaryColor
            } else {
                dateLabel.textColor = Colors.sharedInstance.primaryTextColor
            }
            
            let fbPosts = FireBasePosts()
            
            fbPosts.fetchPost(date: date, completion: { (post) in
                DispatchQueue.main.async {
                    self.post = post
                }
            })
            
            topThree = [Post]()
            
            fbPosts.fetchTopThree(date: date) { (keys) in
                if let keys = keys {
                    for key in keys {
                        fbPosts.fetchPost(uid: key, date: date, completion: { (post) in
                            DispatchQueue.main.async {
                                if let post = post {
                                    self.topThree?.append(post)
                                }
                            }
                        })
                    }
                }
            }
            
            let fbChallenges = FireBaseChallenges()
            let cetTime = CETTime()
            
            let challengeDate = cetTime.calendarChallengeDate(date: date)
            
            fbChallenges.fetchChallenge(challengeDate: challengeDate?.timeIntervalSince1970) { (challenge) in
                DispatchQueue.main.async {
                    if let challenge = challenge {
                        self.challengeLabel.text = challenge
                    } else {
                        self.challengeLabel.text = "no challenge found..."
                    }
                }
            }
        }
    }
    
    var topThree: [Post]? {
        didSet{
            guard let topThree = topThree else { return }
            
            if topThree.count == 3 {
                let gold = topThree[0]
                let silver = topThree[1]
                let bronze = topThree[2]
                
                goldImage.loadImage(urlString: gold.imageUrl)
                silverImage.loadImage(urlString: silver.imageUrl)
                bronzeImage.loadImage(urlString: bronze.imageUrl)
            }
        }
    }
    
    var post: Post? {
        didSet {
            userImageView.loadImage(urlString: post?.imageUrl)
        }
    }
    
    fileprivate let userImageView: UrlImageView = {
        let imageView = UrlImageView()
        imageView.backgroundColor = Colors.sharedInstance.primaryTextColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let goldImage: UrlImageView = {
        let imageView = UrlImageView()
        imageView.backgroundColor = Colors.sharedInstance.goldColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let silverImage: UrlImageView = {
        let imageView = UrlImageView()
        imageView.backgroundColor = Colors.sharedInstance.silverColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let bronzeImage: UrlImageView = {
        let imageView = UrlImageView()
        imageView.backgroundColor = Colors.sharedInstance.bronzeColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.text = "Date"
        return label
    }()
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.layer.borderWidth = 1
//        label.layer.borderColor = Colors.sharedInstance.primaryTextColor.cgColor
        label.text = "Challenge"
        label.textAlignment = .center
        label.textColor = Colors.sharedInstance.primaryTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
        
        let divider = UIView()
        divider.backgroundColor = Colors.sharedInstance.primaryTextColor
        
        addSubview(divider)
        divider.constraintLayout(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                                 padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 1))
    }
    
    fileprivate func layoutViews() {
        addSubview(dateLabel)
        dateLabel.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                   padding: .init(top: 4, left: 4, bottom: 0, right: 4), size: .init(width: 0, height: 15))
        
        let stackView = UIStackView(arrangedSubviews: [goldImage, silverImage, bronzeImage])
        stackView.setUp(vertical: true, spacing: 2)
        
        addSubview(stackView)
        stackView.constraintLayout(top: dateLabel.bottomAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor,
                                   padding: .init(top: 4, left: 8, bottom: 4, right: 4), size: .init(width: (frame.size.width/3) - 8, height: 0))
        
        addSubview(challengeLabel)
        challengeLabel.constraintLayout(top: bronzeImage.topAnchor, leading: leadingAnchor, trailing: stackView.leadingAnchor, bottom: bronzeImage.bottomAnchor,
                                        padding: .init(top: 0, left: 4, bottom: 0, right: 4))
        
        addSubview(userImageView)
        userImageView.constraintLayout(top: stackView.topAnchor, leading: dateLabel.leadingAnchor, trailing: stackView.leadingAnchor, bottom: silverImage.bottomAnchor,
                                       padding: .init(top: 0, left: 0, bottom: 0, right: 4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
