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
    
    fileprivate let cetTime = CETTime()
    
    func fetchWinner(completion: @escaping([TopListScore]?, String?) -> ()) {
        fetchChallengeKey(date: cetTime.challengeTimeDoubleYesterDay()) { (key, description, challengeDate) in
            if let key = key {
                self.fetchList(key: key, date: challengeDate, completion: { (topList) in
                    completion(topList, description)
                })
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func fetchToday(completion: @escaping([TopListScore]?, String?) -> ()) {
        fetchChallengeKey(date: cetTime.challengeTimeYesterday()) { (key, description, challengeDate) in
            if let key = key {
                self.fetchList(key: key, date: challengeDate, completion: { (topList) in
                    completion(topList, description)
                })
            } else {
                completion(nil, nil)
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
                
                let topListScore = TopListScore(uid: uid, score: score, user: true)
                
                topListScore.fetchData {
                    topList.append(topListScore)
                    if topList.count == data.count {
                        completion(topList)
                    }
                }
            }
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
                
                let topListScore = TopListScore(uid: uid, score: score, user: true)
                
                topListScore.fetchData {
                    topList.append(topListScore)
                    if topList.count == data.count {
                        completion(topList)
                    }
                }
            }
        }
    }
    
    fileprivate func fetchList(key: String, date: TimeInterval, completion: @escaping ([TopListScore]?) -> ()) {
        voteRef.child(key).queryOrderedByValue().queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                completion(nil)
                return
            }
            
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
                
                let topListScore = TopListScore(uid: uid, score: score, user: false, challengeDate: date)
                
                topListScore.fetchData {
                    topList.append(topListScore)
                    if topList.count == data.count {
                        completion(topList)
                    }
                }
            }
        }
    }
    
    fileprivate func fetchChallengeKey(date: Date?, completion: @escaping (String?, String?, TimeInterval) -> ()) {
        guard let challengeDate = date?.timeIntervalSince1970 else { return }
        
        challengeRef.queryOrdered(byChild: DatabaseReference.challengeDate.rawValue).queryEqual(toValue: challengeDate).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(nil, nil, challengeDate)
                return
            }
            
            var key : String? = nil
            var description: String? = nil
            
            for item in data {
                let dictionary = item.value as? [String: Any]
                key = item.key
                description = dictionary?[DatabaseReference.challengeDescription.rawValue] as? String
            }
            
            guard let fetchedKey = key else {
                completion(nil, nil, challengeDate)
                return
            }
            
            completion(fetchedKey, description, challengeDate)
        }
    }
}
