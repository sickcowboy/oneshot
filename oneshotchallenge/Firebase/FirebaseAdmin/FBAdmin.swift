//
//  FBAdmin.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-07-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FBAdmin {
    fileprivate let fbChallenge = FireBaseChallenges()
    fileprivate let fbPosts = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let partisipantsRef = Database.database().reference(withPath: DatabaseReference.participants.rawValue)
    
    fileprivate let cetTime = CETTime()
    
    func fetchAllPosts(completion: @escaping ([Post]?) -> ()) {
        fbChallenge.fetchChallenge { (challenge) in
            self.fbPosts.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                var posts = [Post]()
                
                for item in data {
                    guard let post = item.children.allObjects as? [DataSnapshot] else {
                        completion(nil)
                        return
                    }
                    
                    for postItem in post {
                        guard let postDic = postItem.value as? [String: Any] else { return }
                        let post = Post(dictionary: postDic, userId: item.key)
                        
                        guard let challengeDate = self.cetTime.challengeTimeToday()?.timeIntervalSince1970 else { return }
                        if post.challengeDate == challengeDate {
                            posts.append(post)
                        }
                    }
                }
                completion(posts)
            })
        }
    }
    
    func checkPartisipant(completion: @escaping ([String]?) -> ()) {
        fbChallenge.fetchChallenge { (challenge) in
            guard let challengeId = challenge?.key else {
                completion(nil)
                return
            }
            
            self.partisipantsRef.child(challengeId).observeSingleEvent(of: .value) { (snapshot) in
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                var userIds = [String]()
                for item in data {
                    userIds.append(item.key)
                }
                
                completion(userIds)
            }
        }
    }
}
