//
//  FireBaseStorage.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-07.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class FireBaseStorage {
    fileprivate let databaseRef = Database.database().reference(withPath: DatabaseReference.posts.rawValue)
    fileprivate let storageRef = Storage.storage().reference(withPath: DatabaseReference.posts.rawValue)
    
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
                
                guard let imageUrl = url?.absoluteString else { return }
                self.uploadImageUrl(uid: uid, url: imageUrl)
                completion(nil)
            })
        }
    }
    
    fileprivate func uploadImageUrl(uid: String, url: String) {
        let value: [String: Any] = [DatabaseReference.imageUrl.rawValue: url,
                                    DatabaseReference.date.rawValue: Date().timeIntervalSince1970]
        
        databaseRef.child(uid).childByAutoId().setValue(value)
    }
}
