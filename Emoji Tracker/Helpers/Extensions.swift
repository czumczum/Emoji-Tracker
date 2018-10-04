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
    
    func getYesterdayDate(with date : Date = currentDateObj.now.startOfTheDay() ?? currentDateObj.now) -> Date {
        guard let yesterday = Calendar.current.date(
            byAdding: .hour,
            value: -24,
            to: date) else {
                fatalError("Cannot get yesterday's date")
        }
        return yesterday
    }
    
    func getTomorrowDate(with date : Date = currentDateObj.now) -> Date {
        guard let current = date.startOfTheDay() else {
            fatalError("current date coudn't be retreived")
        }
        guard let tomorrow = Calendar.current.date(
            byAdding: .hour,
            value: 24,
            to: current) else {
                fatalError("Cannot get tomorrow's date")
        }
        return tomorrow
    }
    
    func getTEndOfTheDay(with date : Date = currentDateObj.now) -> Date {
        guard let current = date.startOfTheDay() else {
            fatalError("current date coudn't be retreived")
        }
        guard let tomorrow = Calendar.current.date(
            byAdding: .second,
            value: 86399,
            to: current) else {
                fatalError("Cannot get tomorrow's date")
        }
        return tomorrow
    }
    
    func addOneYear(with date : Date = currentDateObj.now) -> Date {
        guard let nextYear = Calendar.current.date(
            byAdding: .year,
            value: 1,
            to: date) else {
                fatalError("Cannot get the next year's date")
        }
        return nextYear
    }
    
    func subtractOneYear(with date : Date = currentDateObj.now) -> Date {
        guard let previousYear = Calendar.current.date(
            byAdding: .year,
            value: -1,
            to: date) else {
                fatalError("Cannot get the next year's date")
        }
        return previousYear
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
        return dateFormatter.string(from: self as Date)
    }
    
    func getDayDate() -> Int? {
        let calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.dateComponents([.day], from: self)
        return components.day
    }
    
    func getDayNumber() -> Int16 {
        let calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        let number = Int16(components.weekday ?? 0)
        return number
    }
    
    func startOfTheDay() -> Date? {
        let dateFormatter = DateFormatter().getFormattedDate()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let stringDate = dateFormatter.string(from: self)
        return dateFormatter.date(from: stringDate)
    }
    
    func endOfTheDay() -> Date? {
        let dateFormatter = DateFormatter().getFormattedDate()
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        let calendar = Calendar.init(identifier: .gregorian)
        let endDaydate = calendar.getTEndOfTheDay(with: self)
        let stringDate = dateFormatter.string(from: endDaydate)
        return dateFormatter.date(from: stringDate)
    }
    
}

extension DateFormatter {
    func getFormattedDate() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
    
    func getCalendarFormatted() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        dateFormatter.locale = Calendar.current.locale
        
        return dateFormatter
    }
}

extension Dictionary where Value:Comparable {
    
    var sortedByValue:[(Key,Value)] {return Array(self).sorted{$0.1 > $1.1}}

}

// MARK: - Usage
// string[0..<3]
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
} 

