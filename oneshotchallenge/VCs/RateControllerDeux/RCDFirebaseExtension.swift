//
//  RCDFirebaseExtension.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-16.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension RateControllerDeux {
    func fetchKey() {
        let fbChallenges = FireBaseChallenges()
        
        fbChallenges.fetchChallenge(challengeDate: cetTime.challengeTimeYesterday()?.timeIntervalSince1970) { (challenge) in
            if let challenge = challenge {
                self.challenge = challenge
            } else {
                // TODO : Something went wrong
                DispatchQueue.main.async {
                    self.activityIndication(loading: false)
                    self.setUpRefresh()
                }
            }
        }
    }
    
    func checkIfUserHasPosted(key: String) {
        let fbPosts = FireBasePosts()
        guard let challengeDate = cetTime.challengeTimeToday() else { return }
        
        activityIndication(loading: true)
        
        fbPosts.fetchPost(date: challengeDate) { (post) in
            if post != nil {
                self.checkIfDone(key: key)
                return
            }
            
            DispatchQueue.main.async {
                self.activityIndication(loading: false)
                self.setUpLockedLabel(done: false)
            }
        }
    }
    
    func checkIfDone(key: String) {
        fbRatings.checkIfVoteIsDone(key: key) { (count) in
            if let count = count {
                if count >= 5 {
                    DispatchQueue.main.async {
                        self.activityIndication(loading: false)
                        self.setUpLockedLabel(done: true)
                    }
                } else {
                    self.voteCount = count
                    self.fetchPartisipants()
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndication(loading: false)
                    self.setUpRefresh()
                }
                // TODO : Something went wrong
            }
        }
    }
    
    func fetchPartisipants() {
        fbRatings.fetchPartisipants(key: challenge?.key) { (partisipants) in
            DispatchQueue.main.async {
                self.activityIndication(loading: false)
                
                if let partisipants = partisipants {
                    self.partisipants = partisipants
                } else {
                    // TODO : Something went wrong
                    self.activityIndication(loading: false)
                    self.setUpRefresh()
                }
            }
        }
    }
    
    func fetchPosts(partisipants: [String]) {
        if partisipants.isEmpty {
            activityIndication(loading: false)
            setUpRefresh()
            return
        }
        
        var partisipants = partisipants
        
        activityIndication(loading: true)
        
        posts = [Post]()
        
        guard let timeInterval = cetTime.challengeTimeYesterday()?.timeIntervalSince1970 else { return }
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let fbPosts = FireBasePosts()
        
        var index = 0
        
        for (partisipant) in partisipants {
            fbPosts.fetchPost(uid: partisipant, date: date) { (post) in
                if let post = post {
                    self.posts?.append(post)
                } else {
                    partisipants.remove(at: index)
                    index -= 1
                }
                index += 1
                
                if self.posts?.count == partisipants.count {
                    self.doneFetching()
                }
            }
        }
    }
    
    fileprivate func doneFetching() {
        DispatchQueue.main.async {
            if (self.posts?.count ?? 0) % 2 != 0 {
                self.posts?.removeLast()
            }
            
            self.activityIndication(loading: false)
            self.setUpVoteView()
            return
        }
    }
    
    func addPartisipant() {
        fbRatings.addPartisipant()
    }
}
