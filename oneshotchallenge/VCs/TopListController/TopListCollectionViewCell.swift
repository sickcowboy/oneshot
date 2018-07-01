//
//  TopListCollectionViewCell.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-14.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class TopListControllerCell: UICollectionViewCell {
    
    var placement: Int? {
        didSet{
            setStarColor()
        }
    }
    
    var today = false
    
    var topListScore: TopListScore? {
        didSet{
            nameLabel.text = ""
            voteLabel.text = ""
            framePhotoView.photoImageView.image = nil
            
            guard let topListScore = topListScore else { return }
            let fbUser = FireBaseUser()
            
            fbUser.fetchUser(uid: topListScore.uid) { (user) in
                DispatchQueue.main.async {
                    var votes = "votes"
                    if topListScore.score == 1 {
                        votes = "vote"
                    }
                    
                    self.voteLabel.text = "\(topListScore.score) \(votes)"
                    self.nameLabel.text = user?.username
                }
                
                if !self.today {
                    self.post = nil
                    self.imageUrl = user?.profilePicUrl
                } else {
                    let fbPosts = FireBasePosts()
                    let cetTime = CETTime()
                    fbPosts.fetchPost(uid:topListScore.uid, date: cetTime.challengeTimeYesterday(), completion: { (post) in
                        self.post = post
                    })
                }
            }
        }
    }
    
    var post: Post? {
        didSet {
            imageUrl = post?.imageUrl
        }
    }
    
    var imageUrl: String? {
        didSet {
            framePhotoView.photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let image = #imageLiteral(resourceName: "Star")
        let iV = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        iV.contentMode = .scaleAspectFit
        iV.clipsToBounds = true
        return iV
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Colors.sharedInstance.primaryTextColor
        return label
    }()
    
    fileprivate let voteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    fileprivate lazy var framePhotoView = FramedPhotoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.sharedInstance.primaryColor
        
        addSubview(framePhotoView)
        framePhotoView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor,
                                        padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        framePhotoView.squareByHeightAnchor()
        
        addSubview(nameLabel)
        nameLabel.constraintLayout(top: framePhotoView.topAnchor, leading: framePhotoView.trailingAnchor, trailing: trailingAnchor,
                                   bottom: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        
        addSubview(voteLabel)
        voteLabel.constraintLayout(top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                   padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        
        addSubview(imageView)
        imageView.constraintLayout(top: voteLabel.bottomAnchor, leading: nameLabel.leadingAnchor, trailing: nil, bottom: nil,
                                   padding: .init(top: 2, left: 0, bottom: 0, right: 0),
                                   size: .init(width: 25, height: 25))
    }
    
    fileprivate func setUpViews() {
        addSubview(framePhotoView)
        framePhotoView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor,
                                            padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        framePhotoView.squareByHeightAnchor()
        
        addSubview(nameLabel)
        nameLabel.constraintLayout(top: framePhotoView.topAnchor, leading: framePhotoView.trailingAnchor, trailing: trailingAnchor,
                                   bottom: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        
        addSubview(voteLabel)
        voteLabel.constraintLayout(top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                   padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        
        addSubview(imageView)
        imageView.constraintLayout(top: voteLabel.bottomAnchor, leading: nameLabel.leadingAnchor, trailing: nil, bottom: nil,
                                   padding: .init(top: 2, left: 0, bottom: 0, right: 0),
                                   size: .init(width: 25, height: 25))
    }
    
    fileprivate func setUpLabels(imageLeadingAnchor: NSLayoutXAxisAnchor? = nil) {
        let newLeadingAnchor = imageLeadingAnchor ?? leadingAnchor
        addSubview(nameLabel)
        nameLabel.constraintLayout(top: nil, leading: imageView.trailingAnchor, trailing: trailingAnchor, bottom: nil,
                                   centerY: imageView.centerYAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        
        addSubview(voteLabel)
        voteLabel.constraintLayout(top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                   padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        
        addSubview(imageView)
        imageView.constraintLayout(top: topAnchor, leading: newLeadingAnchor, trailing: nil, bottom: nil,
                                   padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 25))
        imageView.squareByHeightAnchor()
    }
    
    fileprivate func setStarColor() {
        guard let placement = placement else { return }
        
        imageView.isHidden = false
        
        switch placement {
        case 0:
            imageView.tintColor = Colors.sharedInstance.goldColor
            return
        case 1:
            imageView.tintColor = Colors.sharedInstance.silverColor
            return
        case 2:
            imageView.tintColor = Colors.sharedInstance.bronzeColor
            return
        default:
            imageView.isHidden = true
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
