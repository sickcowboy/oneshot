//
//  FirebaseDebugOptions.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-16.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

class FBDebug {
    static let sharedInstance = FBDebug()
    let userVotesRef = Database.database().reference(withPath: DatabaseReference.userVotes.rawValue)
    let userPosts = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    let usersRef = Database.database().reference(withPath: DatabaseReference.users.rawValue)
    let participantRef = Database.database().reference(withPath: DatabaseReference.participants.rawValue)
    
    func deleteUserVotes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userVotesRef.child(uid).removeValue()
    }
    
    func deletePost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let cetTime = CETTime()
        guard let challengeTime = cetTime.challengeTimeToday() else { return }
        
        userPosts.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeTime.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in data {
                self.userPosts.child(uid).child(item.key).removeValue()
            }
        }
    }
    
    func resetBoarding() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        usersRef.child(uid).child(DatabaseReference.isOnBoarded.rawValue).removeValue()
        usersRef.child(uid).child(DatabaseReference.profilePicURL.rawValue).removeValue()
    }
    
    func addParticipant() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fbChallenge = FireBaseChallenges()
        fbChallenge.fetchChallenge { (challenge) in
            if let challenge = challenge {
                self.participantRef.child(challenge.key).child(uid).setValue(1)
            }
        }
    }
}
