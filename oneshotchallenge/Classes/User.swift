//
//  User.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

struct LocalUser {
    var username: String
    var memberSince: Double?
    var profileDeleteDate: TimeInterval?
    
    init(dictionary: [String: Any]) {
        self.username = dictionary[DatabaseReference.username.rawValue] as? String ?? ""
        self.memberSince = dictionary[DatabaseReference.memberSince.rawValue] as? Double
        self.profileDeleteDate = dictionary[DatabaseReference.profileDeleteDate.rawValue] as? TimeInterval ?? Date().timeIntervalSince1970
    }
}
