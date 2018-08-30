//
//  CurrentDate.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/3/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

let currentDateObj = CurrentDate()

class CurrentDate {
    
    var now = Date().toLocalTime()
    var yesterday : Date = Date()
    var tomorrow : Date = Date()
    
    private let calendar = Calendar(identifier: .gregorian)
    
    func turnBackTime() {
        now = calendar.getYesterdayDate()
        setYesterdayAndTomorrow()
    }
    
    func backToTheFuture() {
        now = calendar.getTomorrowDate()
        setYesterdayAndTomorrow()
    }
    
    func oneYearBack() -> Date {
        return calendar.subtractOneYear()
    }
    
    func oneYearForward() -> Date {
        return calendar.addOneYear()
    }
    
    func restoreTimeLine() {
        now = Date().toLocalTime()
        setYesterdayAndTomorrow()
    }
    
    func setYesterdayAndTomorrow() {
        yesterday = calendar.getYesterdayDate()
        tomorrow = calendar.getTomorrowDate()
    }
    
}
