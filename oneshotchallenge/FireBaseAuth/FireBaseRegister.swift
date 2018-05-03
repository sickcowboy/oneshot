//
//  FireBaseRegister.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth

class FireBaseRegister {
    fileprivate let auth = Auth.auth()
    
    func registerWithEmail(email: String, password: String, completion: @escaping (Error?) -> ()) {
        auth.createUser(withEmail: email, password: password) { (nil, error) in
            completion(error)
        }
    }
}
