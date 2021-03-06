//
//  FireBaseVote.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FBVote {
    fileprivate let allTimeRef = Database.database().reference(withPath: DatabaseReference.allTimeVotes.rawValue)
    fileprivate let monthRef  = Database.database().reference(withPath: DatabaseReference.monthVotes.rawValue)
    fileprivate let voteRef = Database.database().reference(withPath: DatabaseReference.votes.rawValue)
    fileprivate let userVoteRef = Database.database().reference(withPath: DatabaseReference.userVotes.rawValue)
    
    static let sharedInstance = FBVote()
    
    func vote(uid: String?, id: String?, month: String?) {
        guard let uid = uid else { return }
        guard let id = id else { return }
        guard let month = month else { return }
        
        if month.isEmpty { return }
        
        allTimeVote(uid: uid)
        postVote(uid: uid, id: id)
        monthVote(uid: uid, month: month)
        userVote(id: id, votedFor: uid)
    }
    
    fileprivate func allTimeVote(uid: String) {
        allTimeRef.child(uid).runTransactionBlock({ (currentData) -> TransactionResult in
            var votes = currentData.value as? Int ?? 0
                votes += 1
                
                currentData.value = votes
                
                return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                debugPrint("All time error: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func postVote(uid: String, id: String) {
        voteRef.child(id).child(uid).runTransactionBlock({ (currentData) -> TransactionResult in
            var votes = currentData.value as? Int ?? 0
                votes += 1
                
                currentData.value = votes
                
                return TransactionResult.success(withValue: currentData)
        }) { (error, commited, snapshot) in
            if let error = error {
                debugPrint("Vote error: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func monthVote(uid: String, month: String) {
        monthRef.child(month).child(uid).runTransactionBlock({ (currentData) -> TransactionResult in
                var votes = currentData.value as? Int ?? 0
                votes += 1
                
                currentData.value = votes
                
                return TransactionResult.success(withValue: currentData)
        }) { (error, commited, snapshot) in
            if let error = error {
                debugPrint("Month error: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func userVote(id: String, votedFor: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userVoteRef.child(uid).child(id).child(votedFor).setValue(1)
    }
    
    func fetchNumberOfVotes(key: String, uid: String? = nil, completion: @escaping (Int?) -> ()) {
        guard let uid = uid ?? Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        voteRef.child(key).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let votes = snapshot.value as? Int else {
                completion(nil)
                return
            }
            
            completion(votes)
        }
    }
}
