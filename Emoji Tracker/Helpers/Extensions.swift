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
    
    func getYesterdayDate(with date : Date = currentDateObj.now) -> Date {
        guard let yesterday = Calendar.current.date(
            byAdding: .hour,
            value: -24,
            to: date) else {
                fatalError("Cannot get yesterday's date")
        }
        return yesterday
    }
    
    func getTomorrowDate(with date : Date = currentDateObj.now) -> Date {
        guard let tomorrow = Calendar.current.date(
            byAdding: .hour,
            value: 24,
            to: date) else {
                fatalError("Cannot get tomorrow's date")
        }
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
        return dateFormatter.string(from: self as Date)
    }
    
    func getDayDate() -> Int? {
        let calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.dateComponents([.day], from: self)
        print(self)
        print(components)
        return components.day
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
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let calendar = Calendar.init(identifier: .gregorian)
        let endDaydate = calendar.getTomorrowDate(with: self)
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
}

