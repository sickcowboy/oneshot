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
    
    func deleteUserVotes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userVotesRef.child(uid).removeValue()
    }
}
