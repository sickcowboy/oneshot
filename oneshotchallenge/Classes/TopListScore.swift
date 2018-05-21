//
//  TopListScore.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

struct TopListScore {
    var uid: String
    var score: Int
    
    init(uid: String, score:Int) {
        self.uid = uid
        self.score = score
    }
}
