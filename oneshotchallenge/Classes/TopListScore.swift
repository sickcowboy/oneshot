//
//  TopListScore.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class TopListScore {
    fileprivate let urlImageFetcher = UrlImageFetcher()
    fileprivate var fbUser: FireBaseUser?
    fileprivate var fbPosts: FireBasePosts?
    
    var uid: String
    var score: Int
    var challengeDate: TimeInterval
    var fetchProfilePic: Bool
    
    var username: String?
    var image: UIImage? 
    
    init(uid: String, score:Int, user: Bool, challengeDate: TimeInterval = 0) {
        self.uid = uid
        self.score = score
        self.challengeDate = challengeDate
        self.fetchProfilePic = user
    }
    
    func fetchData(completion: @escaping () -> ()) {
        fbUser = FireBaseUser()
        fbUser?.fetchUser(uid: uid, completion: { (user) in
            self.username = user?.username
            
            if self.fetchProfilePic {
                self.fetchImage(imageUrl: user?.profilePicUrl, completion: {
                    completion()
                })
                return
            }
            self.fetchPostImageUrl(completion: {
                completion()
            })
        })
    }
    
    fileprivate func fetchImage(imageUrl: String?, completion: @escaping () -> ()) {
        urlImageFetcher.loadImage(urlString: imageUrl, completion: { (image) in
            self.image = image
            completion()
        })
    }
    
    fileprivate func fetchPostImageUrl(completion: @escaping () -> ()) {
        fbPosts = FireBasePosts()
        
        fbPosts?.fetchPost(uid: uid, date: Date(timeIntervalSince1970: challengeDate), completion: { (post) in
            self.fetchImage(imageUrl: post?.imageUrl, completion: {
                completion()
            })
        })
    }
}
