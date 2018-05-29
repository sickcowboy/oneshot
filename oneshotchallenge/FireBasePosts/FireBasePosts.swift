//
//  FireBasePosts.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FireBasePosts {
    fileprivate let postRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let storageRef = Storage.storage().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let challengeRef = Database.database().reference(withPath: DatabaseReference.challenges.rawValue)
    fileprivate let voteRef = Database.database().reference(withPath: DatabaseReference.votes.rawValue)
    
    fileprivate let cetTime = CETTime()
    
    func fetchPost(uid: String? = nil, date: Date? = nil, completion: @escaping (Post?) -> ()) {
        guard let uid = uid ?? Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let date = date ?? Date()
        guard let challengeDate = cetTime.calendarChallengeDate(date: date) else {
            completion(nil)
            return
        }
        
        postRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                for item in data {
                    guard let dictionary = item.value as? [String: Any] else {
                        completion(nil)
                        return
                    }
                    
                    let post = Post(dictionary: dictionary, userId: uid)
                    completion(post)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchUserPosts(completion: @escaping ([Post]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        postRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var posts = [Post]()
            for item in data {
                guard let dictionary = item.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                let post = Post(dictionary: dictionary, userId: uid)
                posts.append(post)
            }
            
            completion(posts)
        }
    }
    
    func fetchUserFeed(completion: @escaping ([Challenge]?) -> ()) {
        guard let today = cetTime.challengeTimeYesterday() else {
            completion(nil)
            return
        }
        
        challengeRef.queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEnding(atValue: today.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var challenges = [Challenge]()
            for item in data {
                guard let dictionary = item.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                let challenge = Challenge(dictionary: dictionary, key: item.key)
                
                challenges.append(challenge)
            }
            
            completion(challenges)
        }
    }
    
    func startPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let cetTime = CETTime()
        guard let challengeTime = cetTime.challengeTimeToday() else { return }
        
        let value : [String: Any] = [DatabaseReference.challengeDate.rawValue: challengeTime.timeIntervalSince1970,
                                     DatabaseReference.startDate.rawValue: Date().timeIntervalSince1970]
        
        postRef.child(uid).childByAutoId().setValue(value)
    }
    
    func uploadPost(image: UIImage, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else { return}
        let uuid = UUID().uuidString
        
        let reference = storageRef.child(uid).child(uuid)
        
        reference.putData(imageData, metadata: nil) { (data, error) in
            if let error = error {
                completion(error)
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.fetchChallengeKey(completion: { (key) in
                    if let key = key {
                        guard let imageUrl = url?.absoluteString else { return }
                        self.uploadImageUrl(uid: uid, challengeKey: key, url: imageUrl)
                        completion(nil)
                    } else {
                        // TODO : ERROR
                    }
                })
            })
        }
    }
    
    fileprivate func fetchChallengeKey(completion: @escaping (String?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let cetTime = CETTime()
        guard let challengeTime = cetTime.challengeTimeToday() else { return }
        
        postRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeTime.timeIntervalSince1970)
            .observeSingleEvent(of: .value) { (snapshot) in
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                for item in data {
                    completion(item.key)
                }
        }
    }
    
    func fetchTopThree(date: Date?, completion: @escaping([String]?) -> ()) {
        guard let date = date else {
            completion(nil)
            return
        }
        
        guard let challengeDate = cetTime.calendarChallengeDate(date: date) else {
            completion(nil)
            return
        }
        
        challengeRef.queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for item in data {
                    self.fetchTopThreeUid(key: item.key, completion: { (keys) in
                        guard let keys = keys else {
                            completion(nil)
                            return
                        }
                        
                        completion(keys.reversed())
                    })
                }
            }
        }
    }
    
    fileprivate func fetchTopThreeUid(key: String, completion: @escaping([String]?) -> ()) {
        voteRef.child(key).queryOrderedByValue().queryLimited(toLast: 3).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                var keys = [String]()
                for item in data {
                    keys.append(item.key)
                }
                
                completion(keys)
            } else {
                completion(nil)
            }
        }
    }
    
    fileprivate func uploadImageUrl(uid: String, challengeKey: String, url: String) {
        let value: [String: Any] = [DatabaseReference.imageUrl.rawValue: url,
                                    DatabaseReference.date.rawValue: Date().timeIntervalSince1970]
        
        postRef.child(uid).child(challengeKey).updateChildValues(value)
    }
}
