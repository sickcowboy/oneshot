//
//  TopListScore.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol TopListDelegate:class {
    func finishedFetch()
}

class TopListScore {
    weak var delegate: TopListDelegate?
    
    fileprivate let urlImageFetcher = UrlImageFetcher()
    fileprivate var fbUser: FireBaseUser?
    fileprivate var fbPosts: FireBasePosts?
    
    var uid: String
    var score: Int
    var challengeDate: TimeInterval
    var fetchProfilePic: Bool
    
    var username: String?
    var image: UIImage? {
        didSet {
            delegate?.finishedFetch()
        }
    }
    
    init(uid: String, score:Int, user: Bool, challengeDate: TimeInterval = 0) {
        self.uid = uid
        self.score = score
        self.challengeDate = challengeDate
        self.fetchProfilePic = user
    }
    
    func fetchData() {
        if username != nil && image != nil { return }
        
        fbUser = FireBaseUser()
        fbUser?.fetchUser(uid: uid, completion: { (user) in
            DispatchQueue.main.async {
                self.username = user?.username
            }
            if self.fetchProfilePic {
                self.fetchImage(imageUrl: user?.profilePicUrl)
                return
            }
            self.fetchPostImageUrl()
        })
    }
    
    fileprivate func fetchImage(imageUrl: String?) {
        urlImageFetcher.loadImage(urlString: imageUrl, completion: { (image) in
            DispatchQueue.main.async {
                self.image = image
            }
        })
    }
    
    fileprivate func fetchPostImageUrl() {
        fbPosts = FireBasePosts()
        
        fbPosts?.fetchPost(uid: uid, date: Date(timeIntervalSince1970: challengeDate), completion: { (post) in
            self.fetchImage(imageUrl: post?.imageUrl)
        })
    }
}
