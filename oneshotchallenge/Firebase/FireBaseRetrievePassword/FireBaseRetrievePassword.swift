//
//  FireBaseRetrievePassword.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-05-30.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import FirebaseAuth

class FireBaseRetrievePassword {
    
    func retrieveFBPassword(email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            completion(error)
        }
    }
}
