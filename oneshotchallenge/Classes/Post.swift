//
//  Post.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

struct Post {
    var date: TimeInterval
    var startDate: TimeInterval
    var challengeDate: TimeInterval
    var imageUrl: String
    var userId: String
    
    init(dictionary: [String: Any], userId: String) {
        self.date = dictionary[DatabaseReference.date.rawValue] as? TimeInterval ?? Date().timeIntervalSince1970
        self.imageUrl = dictionary[DatabaseReference.imageUrl.rawValue] as? String ?? ""
        self.startDate = dictionary[DatabaseReference.startDate.rawValue] as? TimeInterval ?? Date().timeIntervalSince1970
        self.challengeDate = dictionary[DatabaseReference.challengeDate.rawValue] as? TimeInterval ?? Date().timeIntervalSince1970
        self.userId = userId
    }
}
