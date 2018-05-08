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
    var imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.date = dictionary[DatabaseReference.date.rawValue] as? TimeInterval ?? Date().timeIntervalSince1970
        self.imageUrl = dictionary[DatabaseReference.imageUrl.rawValue] as? String ?? ""
    }
}
