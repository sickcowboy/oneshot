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
    fileprivate let challengeRef = Database.database().reference(withPath: DatabaseReference.challenges.rawValue)
    fileprivate let partisipantsRef = Database.database().reference(withPath: DatabaseReference.participants.rawValue)
    fileprivate let ratingRef = Database.database().reference(withPath: DatabaseReference.ratings.rawValue)
    fileprivate let userVotesRef = Database.database().reference(withPath: DatabaseReference.userVotes.rawValue)
    
    fileprivate let fbPosts = FireBasePosts()
    
    var userVotes : [String]? {
        didSet{
            
        }
    }
    
    func fetchPartisipants(key: String?, completion: @escaping ([String]?) -> ()) {
        guard let key = key else {
            completion(nil)
            return
        }
        
        self.fetchUserVotes(key: key, completion: { (userVotes) in
            self.fetchPartisipants(key: key, userVotes: userVotes, completion: { (partisipants) in
                completion(partisipants)
            })
        })
    }
    
    fileprivate func fetchUserVotes(key: String, completion: @escaping([String: Any]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        userVotesRef.child(uid).child(key).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            completion(dictionary)
        }
    }
    
    fileprivate func fetchPartisipants(key: String, userVotes: [String: Any]?, completion: @escaping ([String]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        var userVotes = userVotes ?? [String: Any]()
        userVotes[uid] = 1
        
        partisipantsRef.child(key).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var partisipants = [String]()
            for item in data {
                if let _ = userVotes[item.key] as? Int {
                    
                } else {
                    partisipants.append(item.key)
                }
                
                if 20 - userVotes.count == partisipants.count {
                    completion(partisipants)
                    return
                }
            }
            
            completion(partisipants)
        }
    }
    
    func checkIfVoteIsDone(key: String, completion: @escaping (UInt?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        userVotesRef.child(uid).child(key).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion(snapshot.childrenCount)
            } else {
                completion(0)
            }
        }
    }
    
    func addPartisipant(key: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let key = key else { return }
        
        partisipantsRef.child(key).child(uid).setValue(1)
    }
}
