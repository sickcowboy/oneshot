//
//  CalendarCell.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var challenge: Challenge? {
        didSet{
            reset()
            
            guard let challenge = challenge else { return }
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            
            let date = Date(timeIntervalSince1970: challenge.challengeDate)
            let dateString = formatter.string(from: date)
            
            dateLabel.text = dateString
            
            challengeLabel.text = challenge.description
            
            let fbPosts = FireBasePosts()
            fbPosts.fetchPost(date: date) { (post) in
                DispatchQueue.main.async {
                    self.post = post
                }
            }
            
            fbPosts.fetchTopThree(date: date) { (uids) in
                if let uids = uids {
                    for uid in uids {
                        fbPosts.fetchPost(uid: uid, date: date, completion: { (post) in
                            DispatchQueue.main.async {
                                guard let post = post else { return }
                                self.topThree?.append(post)
                            }
                        })
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
    
    fileprivate func reset() {
        topThree = [Post]()
        
        dateLabel.text = nil
        challengeLabel.text = nil
        
        userImageView.image = nil
        goldImage.image = nil
        silverImage.image = nil
        bronzeImage.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
