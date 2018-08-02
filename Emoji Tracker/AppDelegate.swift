//
//  AppDelegate.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: delete later
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

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
        return dateFormatter.string(from: self as Date)
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



