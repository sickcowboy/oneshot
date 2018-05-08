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
}
