//
//  CalendarHeader.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CalendarHeader: UICollectionReusableView {
    var challenge: Challenge? {
        didSet{
            guard let challenge = challenge else { return }
            let date = Date(timeIntervalSince1970: challenge.challengeDate)
            let fbPosts = FireBasePosts()
            fbPosts.fetchPost(date: date) { (post) in
                DispatchQueue.main.async {
                    self.post = post
                }
            }
        }
    }
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            framedPhotoView.photoImageView.loadImage(urlString: post.imageUrl)
        }
    }
    
    let framedPhotoView = FramedPhotoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.sharedInstance.primaryColor
        
        addSubview(framedPhotoView)
        framedPhotoView.constraintLayout(top: topAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, centerX: centerXAnchor,
                                         padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        framedPhotoView.squareByHeightAnchor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
