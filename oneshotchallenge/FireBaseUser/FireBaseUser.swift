//
//  FireBaseUser.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FireBaseUser {
    fileprivate let dataBaseRef = Database.database().reference(withPath: DatabaseReference.users.rawValue)
    
    func fetchUser(uid: String? = nil, completion: @escaping(LocalUser?) -> ()) {
        guard let uid = uid ?? Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        dataBaseRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let user = LocalUser(dictionary: dictionary)
            completion(user)
        }
    }
}
