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
import FirebaseStorage

class FireBaseUser {
    fileprivate let dataBaseRef = Database.database().reference(withPath: DatabaseReference.users.rawValue)
    fileprivate let storageRef = Storage.storage().reference(withPath: DatabaseReference.profilePics.rawValue)
    
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
    
    func checkIfAdmin(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        dataBaseRef.child(uid).child(DatabaseReference.admin.rawValue).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func checkIfOnBoarding(completion: @escaping (Bool?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        dataBaseRef.child(uid).child(DatabaseReference.isOnBoarded.rawValue).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func checkIfProfileImageExists(completion: @escaping (Bool?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        dataBaseRef.child(uid).child(DatabaseReference.profilePicURL.rawValue).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func uploadProfilePic(image: UIImage, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        let refrence = storageRef.child(uid)
        
        refrence.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            refrence.downloadURL(completion: { (url, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                guard let url = url?.absoluteString else { return }
                
                self.uploadProfileImage(uid: uid, url: url, completion: { (error) in
                    completion(error)
                })
            })
            
        }
    }
    
    fileprivate func uploadProfileImage(uid: String, url: String, completion: @escaping (Error?) -> ()) {
        dataBaseRef.child(uid).child(DatabaseReference.profilePicURL.rawValue).setValue(url) { (error, _) in
            completion(error)
        }
    }
}
