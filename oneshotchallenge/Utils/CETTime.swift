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
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = getTimeZone()
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        
        let dateString = dateFormatter.string(from: localTime)
        
        guard let cetTime = dateFormatter.date(from: dateString) else { return nil }
        
        return cetTime
    }
    
    func challengeTimeToday() -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = getTimeZone()
        
        guard let cetTime = timeNow() else { return nil }
        
        return calendar.startOfDay(for: cetTime)
    }
    
    func challengeTimeTomorrow() -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = getTimeZone()
        
        guard let cetTime = timeNow() else { return nil }
        
        guard let cetTomorrow = calendar.date(byAdding: .day, value: 1, to: cetTime) else { return nil }
        
        return calendar.startOfDay(for: cetTomorrow)
    }
    
    func challengeTimeYesterday() -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = getTimeZone()
        
        guard let cetTime = timeNow() else { return nil }
        
        guard let cetTomorrow = calendar.date(byAdding: .day, value: -1, to: cetTime) else { return nil }
        
        return calendar.startOfDay(for: cetTomorrow)
    }
    
    func debugTime() -> TimeInterval? {
//        let calendar = Calendar.current
//
//        guard let cetTime = timeNow() else { return nil }
//
//        guard let cetTomorrow = calendar.date(byAdding: .day, value: -5, to: cetTime) else { return nil }
        
        return 1525816800
    }
    
    func calendarChallengeDate(date: Date) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = getTimeZone()
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        
        let dateString = dateFormatter.string(from: date)
        guard let cetTime = dateFormatter.date(from: dateString) else { return nil }
        
        let calendar = Calendar.current
        return calendar.startOfDay(for: cetTime)
    }
    
    func getTimeZone() -> TimeZone {
        
        let timeZone = TimeZone(abbreviation: "CET")
        
        return timeZone!
    }
}
