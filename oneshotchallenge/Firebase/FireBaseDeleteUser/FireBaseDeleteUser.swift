//
//  FireBaseDeleteUser.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-05-31.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import FireBase

class FireBaseDeleteUser {
    
    let user = Auth.auth().currentUser
    
    var credential: AuthCredential
    
    // Prompt the user to re-provide their sign-in credentials
    
    user?.reauthenticate(with: credential) { error in
    if let error = error {
    // An error happened.
    } else {
    // User re-authenticated.
    }
    }
    
    user?.delete { error in
    if let error = error {
    // An error happened.
    } else {
    // Account deleted.
    }
    }
    
}
