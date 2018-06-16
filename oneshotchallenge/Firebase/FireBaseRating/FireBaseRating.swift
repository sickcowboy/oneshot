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
                if userVotes[item.key] as? Int == nil {
                    partisipants.append(item.key)
                }
                
//                debugPrint("Partisipants: \(partisipants.count)")
//                debugPrint("user votes: \(userVotes.count)")
//                
//                if 20 - userVotes.count == partisipants.count {
//                    if partisipants.count % 2 != 0 {
//                        debugPrint("removing last")
//                        partisipants.removeLast()
//                    }
//                    
//                    completion(partisipants)
//                    return
//                }
            }
            
            if partisipants.count % 2 != 0 {
                debugPrint("removing last")
                partisipants.removeLast()
            }
            completion(partisipants)
        }
    }
    
    func checkIfVoteIsDone(key: String, completion: @escaping (Int?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        userVotesRef.child(uid).child(key).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion(Int(snapshot.childrenCount))
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
