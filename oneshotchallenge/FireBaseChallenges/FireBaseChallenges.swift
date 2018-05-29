//
//  FireBaseChallenges.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FireBaseChallenges {
    fileprivate let databaseRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let challengeRef = Database.database().reference(withPath: DatabaseReference.challenges.rawValue)
    fileprivate let cetTime = CETTime()
    
    func checkIfChallengeIsDone(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let challengeTime = cetTime.challengeTimeToday() else { return }
        
        databaseRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeTime.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                completion(snapshot.exists())
            }
        }
    }
    
    func addChallenge(challenge: String, date: TimeInterval) {
        let value: [String: Any] = [DatabaseReference.challengeDate.rawValue: date, DatabaseReference.challengeDescription.rawValue: challenge]
        
        challengeRef.childByAutoId().setValue(value)
    }
    
    func fetchChallenge(challengeDate: TimeInterval? = nil, completion: @escaping (Challenge?) -> ()) {
        guard let challengeTime = challengeDate ?? cetTime.challengeTimeToday()?.timeIntervalSince1970 else {
            completion(nil)
            return
        }
        
        challengeRef.queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeTime).observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                completion(nil)
                return
            }
            
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            for item in data {
                guard let dictionary = item.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                let challenge = Challenge(dictionary: dictionary, key: item.key)
                completion(challenge)
            }
        }
    }
}
