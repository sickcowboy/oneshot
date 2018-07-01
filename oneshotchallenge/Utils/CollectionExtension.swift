//
//  CollectionExtension.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-07-01.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() -> Array {
        var last = count - 1
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            
            swapAt(last, rand)
            
            last -= 1
        }
        
        return self
    }
}
