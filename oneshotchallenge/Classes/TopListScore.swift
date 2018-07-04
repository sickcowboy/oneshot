//
//  TopListScore.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol TopListDelegate:class {
    func didFinishLoading()
}

class TopListScore {
    weak var delegate: TopListDelegate?
    
    fileprivate let urlImageFetcher = UrlImageFetcher()
    fileprivate var cetTime: CETTime?
    fileprivate var fbUser: FireBaseUser?
    
    var uid: String
    var score: Int
    var name: String?
    
    var image: UIImage? {
        didSet{
            delegate?.didFinishLoading()
        }
    }
    
    init(uid: String, score:Int, user: Bool) {
        self.uid = uid
        self.score = score
        
        if user {
            fetchUserNameAndProfilePicUrl()
            return
        }
    }
    
    fileprivate func fetchUserNameAndProfilePicUrl() {
        fbUser?.fetchUser(uid: uid, completion: { (user) in
            DispatchQueue.main.async {
                self.name = user?.username
            }
            self.fetchImage(imageUrl: user?.profilePicUrl)
        })
    }
    
    fileprivate func fetchImage(imageUrl: String?) {
        urlImageFetcher.loadImage(urlString: imageUrl, completion: { (image) in
            DispatchQueue.main.async {
                self.image = image
            }
        })
    }
    
    fileprivate func fetchPostAndImage() {
        
    }
}
