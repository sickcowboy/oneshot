//
//  MonthKey.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-21.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class MonthKey {
    static let sharedInstance = MonthKey()
    
    fileprivate let monthPreFix = ["jan", "feb", "mar", "apr",
                                   "may", "jun", "jul", "aug",
                                   "sep", "oct", "nov", "dec"]
    
    func monthKey(timeInterval: TimeInterval?) -> String {
        guard let timeInterval = timeInterval else { return "" }
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let calendar = Calendar.current
        
        guard let timeZone = TimeZone(abbreviation: "CET") else { return  "" }
        
        let components = calendar.dateComponents(in: timeZone, from: date)
        guard let year = components.year else { return "" }
        guard let month = components.month else { return "" }
        
        let yearString = String(year)
        let monthString = monthPreFix[month - 1]
        
        return "\(monthString)\(yearString)"
    }
}
