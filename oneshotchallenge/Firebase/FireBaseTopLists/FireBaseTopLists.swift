//
//  FireBaseTopLists.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FBTopLists {
    fileprivate let allTimeRef = Database.database().reference(withPath: DatabaseReference.allTimeVotes.rawValue)
    fileprivate let monthRef  = Database.database().reference(withPath: DatabaseReference.monthVotes.rawValue)
    fileprivate let voteRef = Database.database().reference(withPath: DatabaseReference.votes.rawValue)
    
    fileprivate let challengeRef = Database.database().reference(withPath: DatabaseReference.challenges.rawValue)
    
    func fetchToday(completion: @escaping([TopListScore]?) -> ()) {
        fetchChallengeKey { (key) in
            if let key = key {
                self.fetchTodayList(key: key, completion: { topList in
                    completion(topList?.reversed())
                })
            } else {
                // TODO : something went wrong
            }
        }
    }
    
    func fetchMonth(completion: @escaping([TopListScore]?) -> ()) {
        let cetTime = CETTime()
        guard let challengeDate = cetTime.challengeTimeToday()?.timeIntervalSince1970 else {
            completion(nil)
            return
        }
        
        let month = MonthKey.sharedInstance.monthKey(timeInterval: challengeDate)
        
        monthRef.child(month).queryOrderedByValue().queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var topList = [TopListScore]()
            for item in data {
                let uid = item.key
                guard let score = item.value as? Int else {
                    completion(nil)
                    return
                }
                
                let topListScore = TopListScore(uid: uid, score: score)
                
                topList.append(topListScore)
            }
            
            completion(topList.reversed())
        }
    }
    
    func fetchAllTime(completion: @escaping([TopListScore]?) -> ()) {
        allTimeRef.queryOrderedByValue().queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var topList = [TopListScore]()
            for item in data {
                let uid = item.key
                guard let score = item.value as? Int else {
                    completion(nil)
                    return
                }
                
                let topListScore = TopListScore(uid: uid, score: score)
                
                topList.append(topListScore)
            }
            
            completion(topList.reversed())
        }
    }
    
    fileprivate func fetchTodayList(key: String, completion: @escaping ([TopListScore]?) -> ()) {
        voteRef.child(key).queryOrderedByValue().queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var topList = [TopListScore]()
            for item in data {
                let uid = item.key
                guard let score = item.value as? Int else {
                    completion(nil)
                    return
                }
                
                let topListScore = TopListScore(uid: uid, score: score)
                
                topList.append(topListScore)
            }
            
            completion(topList)
        }
    }
    
    fileprivate func fetchChallengeKey(completion: @escaping (String?) -> ()) {
        let cetTime = CETTime()
        guard let challengeDate = cetTime.challengeTimeYesterday()?.timeIntervalSince1970 else { return }
        
        challengeRef.queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil)
                return
            }
            
            var key : String? = nil
            
            for item in data {
                key = item.key
            }
            
            guard let fetchedKey = key else {
                completion(nil)
                return
            }
            
            completion(fetchedKey)
        }
    }
}
