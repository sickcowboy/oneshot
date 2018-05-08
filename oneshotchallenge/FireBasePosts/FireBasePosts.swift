//
//  FireBasePosts.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FireBasePosts {
    fileprivate let databaseRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    
    func fetchCalendarPost(date: Date, completion: @escaping (Post?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        databaseRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: date.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                for item in data {
                    guard let dictionary = item.value as? [String: Any] else {
                        completion(nil)
                        return
                    }
                    
                    let post = Post(dictionary: dictionary)
                    completion(post)
                }
            } else {
                completion(nil)
            }
        }
    }
}
