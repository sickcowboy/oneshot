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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let goldImage: UrlImageView = {
    let imageView = UrlImageView()
    imageView.backgroundColor = Colors.sharedInstance.goldColor
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    return imageView
    }()
    
    fileprivate let silverImage: UrlImageView = {
        let imageView = UrlImageView()
        imageView.backgroundColor = Colors.sharedInstance.silverColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let bronzeImage: UrlImageView = {
        let imageView = UrlImageView()
        imageView.backgroundColor = Colors.sharedInstance.bronzeColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        dateLabel.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,
                                   padding: .init(top: 4, left: 4, bottom: 0, right: 0))
        
        let size = frame.height - 15
        
        addSubview(userImageView)
        userImageView.constraintLayout(top: dateLabel.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,
                                      padding: .init(top: 4, left: 4, bottom: 0, right: 0), size: .init(width: size, height: size))
        
        addStackView(height: size)
    }
    
    fileprivate func addStackView(height: CGFloat) {
        let stackView = UIStackView(arrangedSubviews: [goldImage, silverImage, bronzeImage])
        stackView.setUp(vertical: false, spacing: 2)
        
        addSubview(stackView)
        stackView.constraintLayout(top: userImageView.topAnchor, leading: userImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil,
                                   padding: .init(top: 0, left: 16, bottom: 0, right: 4), size: .init(width: 0, height: height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
