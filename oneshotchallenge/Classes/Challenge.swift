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
    
    func dateString() -> String {
        let date = Date(timeIntervalSince1970: challengeDate)
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        return formatter.string(from: date)
    }
}
