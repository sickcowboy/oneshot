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
import FirebaseStorage

class FireBasePosts {
    fileprivate let databaseRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let storageRef = Storage.storage().reference(withPath: DatabaseReference.posts.rawValue)
    
    func fetchPost(date: Date? = nil, completion: @escaping (Post?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let cetTime = CETTime()
        let date = date ?? Date()
        guard let challengeDate = cetTime.calendarChallengeDate(date: date) else { return }
        
        databaseRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate.timeIntervalSince1970).observeSingleEvent(of: .value) { (snapshot) in
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
    
    func startPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let cetTime = CETTime()
        guard let challengeTime = cetTime.challengeTimeToday() else { return }
        
        let value : [String: Any] = [DatabaseReference.challengeDate.rawValue: challengeTime.timeIntervalSince1970,
                                     DatabaseReference.startDate.rawValue: Date().timeIntervalSince1970]
        
        databaseRef.child(uid).childByAutoId().setValue(value)
    }
    
    func uploadPost(image: UIImage, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else { return}
        let uuid = UUID().uuidString
        
        let reference = storageRef.child(uid).child(uuid)
        
        reference.putData(imageData, metadata: nil) { (data, error) in
            if let error = error {
                completion(error)
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.fetchChallengeKey(completion: { (key) in
                    if let key = key {
                        guard let imageUrl = url?.absoluteString else { return }
                        self.uploadImageUrl(uid: uid, challengeKey: key, url: imageUrl)
                        completion(nil)
                    } else {
                        // TODO : ERROR
                    }
                })
            })
        }
    }
    
    fileprivate func fetchChallengeKey(completion: @escaping (String?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let cetTime = CETTime()
        guard let challengeTime = cetTime.challengeTimeToday() else { return }
        
        databaseRef.child(uid).queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeTime.timeIntervalSince1970)
            .observeSingleEvent(of: .value) { (snapshot) in
                guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(nil)
                    return
                }
                
                for item in data {
                    completion(item.key)
                }
        }
    }
    
    fileprivate func uploadImageUrl(uid: String, challengeKey: String, url: String) {
        let value: [String: Any] = [DatabaseReference.imageUrl.rawValue: url,
                                    DatabaseReference.date.rawValue: Date().timeIntervalSince1970]
        
        databaseRef.child(uid).child(challengeKey).updateChildValues(value)
    }
}
