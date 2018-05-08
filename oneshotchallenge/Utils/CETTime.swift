//
//  CETTime.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class CETTime {
    func timeNow() -> Date? {
        let localTime = Date()
        guard let timeZone = TimeZone(abbreviation: "CET") else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        
        let dateString = dateFormatter.string(from: localTime)
        guard let cetTime = dateFormatter.date(from: dateString) else { return nil }
        return cetTime
    }
    
    func challengeTimeToday() -> Date? {
        let calendar = Calendar.current
        
        guard let cetTime = timeNow() else { return nil }
        
        return calendar.startOfDay(for: cetTime)
    }
    
    func challengeTimeTomorrow() -> Date? {
        let calendar = Calendar.current
        
        guard let cetTime = timeNow() else { return nil }
        
        guard let cetTomorrow = calendar.date(byAdding: .day, value: 1, to: cetTime) else { return nil }
        
        return calendar.startOfDay(for: cetTomorrow)
    }
}
