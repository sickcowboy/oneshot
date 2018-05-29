//
//  Challenge.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-29.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

struct Challenge {
    var challengeDate: TimeInterval
    var description: String
    var key: String
    
    init(dictionary: [String: Any], key: String) {
        self.challengeDate = dictionary[DatabaseReference.challengeDate.rawValue] as? TimeInterval ?? Date().timeIntervalSince1970
        self.description = dictionary[DatabaseReference.challengeDescription.rawValue] as? String ?? ""
        self.key = key
    }
}
