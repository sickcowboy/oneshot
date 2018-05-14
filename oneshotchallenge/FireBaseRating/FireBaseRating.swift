//
//  File.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FireBaseRating {
    fileprivate let postRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let challengeRef = Database.database().reference(withPath: DatabaseReference.challenges.rawValue)
    fileprivate let partisipantsRef = Database.database().reference(withPath: DatabaseReference.participants.rawValue)
    fileprivate let ratingRef = Database.database().reference(withPath: DatabaseReference.ratings.rawValue)
    
    func fetchPosts(completion: @escaping ([Post]?) -> ()) {
        debugPrint("fetching posts")
        let cetTime = CETTime()
        // TODO : change 'challenge time double yesterday' to 'challenge time yesterday'
        guard let challengeDate = cetTime.challengeTimeDoubleYesterday()?.timeIntervalSince1970 else {
            completion(nil)
            return
        }
        
        challengeRef.queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var key : String? = nil
            
            for item in data {
                key = item.key
            }
            
            guard let fetchedKey = key else {
                completion(nil)
                return
            }
            
            self.fetchPartisipants(key: fetchedKey, completion: { (partisipants) in
                self.fetchUserPosts(partisipants: partisipants, completion: { (posts) in
                    completion(posts)
                })
            })
        }
    }
    
    fileprivate func fetchPartisipants(key: String, completion: @escaping ([String]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        debugPrint(key)
        
        partisipantsRef.child(key).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var partisipants = [String]()
            for item in data {
                if item.key != uid {
                    partisipants.append(item.key)
                }
            }
            
            completion(partisipants)
        }
    }
    
    fileprivate func fetchUserPosts(partisipants: [String]?, completion: @escaping ([Post]?) -> ()) {
        let cetTime = CETTime()
        
        if let partisipants = partisipants {
            // TODO : change 'challenge time double yesterday' to 'challenge time yesterday'
            guard let challengeDate = cetTime.challengeTimeDoubleYesterday()?.timeIntervalSince1970 else {
                completion(nil)
                return
            }
            
            var posts = [Post]()
            
            for partisipant in partisipants {
                postRef.child(partisipant).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate).observeSingleEvent(of: .value) { (snapshot) in
                    guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                        completion(nil)
                        return
                    }
                    
                    
                    for item in data {
                        guard let dictionary = item.value as? [String: Any] else { break }
                        
                        let post = Post(dictionary: dictionary)
                        posts.append(post)
                    }
                    
                    if posts.count == partisipants.count {
                        completion(posts)
                    }
                }
            }
        } else {
            // TODO : something went wrong
        }
    }
}
