//
//  FireBaseDeleteUser.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-01.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth

class FireBaseDeleteUser {
    
    func deleteCurrentUser(user: User, completion: @escaping (Error?) -> ()) {
        
        user.delete { error in
            if let error = error {
                
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
}
