//
//  FireBaseRegister.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FireBaseRegister {
    fileprivate let auth = Auth.auth()
    
    let databaseRef = Database.database().reference(withPath: DatabaseReference.users.rawValue)
    
    func registerWithEmail(email: String, password: String, username: String, completion: @escaping (Error?) -> ()) {
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(error)
                return
            }
            
            self.setUserName(uid: user?.user.uid, username: username)
            completion(nil)
        }
    }
    
    fileprivate func setUserName(uid: String?, username: String) {
        guard let uid = uid else { return }
        
        checkIfUserNameExists(username: username) { (exists) in
            let value: [String: Any] = [DatabaseReference.username.rawValue: username,
                                            DatabaseReference.memberSince.rawValue: Date().timeIntervalSince1970]
                
            self.databaseRef.child(uid).setValue(value)
        }
    }
    
    func checkIfUserNameExists(username: String, completion: @escaping (Bool) -> ()) {
        databaseRef.queryOrdered(byChild: DatabaseReference.username.rawValue).queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
}
