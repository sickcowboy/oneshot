//
//  File.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FireBaseRating {
    fileprivate let postRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let ratingRef = Database.database().reference(withPath: DatabaseReference.ratings.rawValue)
}
