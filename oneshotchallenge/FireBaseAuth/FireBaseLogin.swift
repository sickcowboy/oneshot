//
//  FireBaseLogin.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth

class FireBaseLogin {    
    fileprivate let auth = Auth.auth()
    
    func login(email: String, password: String, completion: @escaping (Error?) -> ()) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            completion(error)
        }
    }
}
