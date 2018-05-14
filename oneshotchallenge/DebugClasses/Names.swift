//
//  Names.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-14.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class Names {
    static let sharedInstance = Names()
    
    fileprivate let firstNames = ["Dennis", "Alice", "Dora", "Caroline", "Wilmer", "Olle", "Robert",
                                  "Sandra", "Dimitrij", "Karsten", "Erla", "Åse", "Lasse", "Hilde",
                                  "Sara", "Hanna", "James", "Henke", "Martin", "Jacob", "Sigvard"]
    
    fileprivate let lastNames = ["Larsson", "Galvén", "Ekberg", "Andersson", "Nilsson", "Olsson",
                                 "Wiksson", "Jackson", "von Tappert", "Engdahl", "Böjerts", "Viik",
                                 "Börjesson", "jr. Frank", "Dillert", "Fikonberg", "Siljasson"]
    
    func rndName() -> String {
        let rndFirst = arc4random_uniform(UInt32(firstNames.count))
        let rndSecond = arc4random_uniform(UInt32(lastNames.count))
        
        let name = "\(firstNames[Int(rndFirst)]) \(lastNames[Int(rndSecond)])"
        
        return name
    }
}
