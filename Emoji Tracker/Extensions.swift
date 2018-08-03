//
//  DataMethods.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/2/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import Foundation
import UIKit

extension Calendar {
    
    func getYesterdayDate() -> Date? {
        let yesterday = Calendar.current.date(
            byAdding: .hour,
            value: -24,
            to: Date().toLocalTime())
        
        return yesterday
    }
    
    func getTomorrowDate() -> Date? {
        let tomorrow = Calendar.current.date(
            byAdding: .hour,
            value: 24,
            to: Date().toLocalTime())
        
        return tomorrow
    }
    
}

extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter().getFormattedDate()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
    
    func getMonth() -> String? {
        let dateFormatter = DateFormatter().getFormattedDate()
        dateFormatter.dateFormat = "LLLL"
        print(dateFormatter.string(from: self as Date))
        return dateFormatter.string(from: self as Date)
    }
    
    func getDayDate() -> Int? {
        let calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.dateComponents([.day], from: self)
        return components.day
    }
    
}

extension DateFormatter {
    func getFormattedDate() -> DateFormatter {
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone.current.abbreviation()
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone ?? "UTC")
        return dateFormatter
    }
}

