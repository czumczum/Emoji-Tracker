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
    
    func turnBackTime() {
        let calendar = Calendar(identifier: .gregorian)
        now = calendar.getYesterdayDate()
        setYesterdayAndTomorrow()
    }
    
    func backToTheFuture() {
        let calendar = Calendar(identifier: .gregorian)
        now = calendar.getTomorrowDate()
        setYesterdayAndTomorrow()
    }
    
    func restoreTimeLine() {
        now = Date().toLocalTime()
        setYesterdayAndTomorrow()
    }
    
    func setYesterdayAndTomorrow() {
        let calendar = Calendar(identifier: .gregorian)
        yesterday = calendar.getYesterdayDate()
        tomorrow = calendar.getTomorrowDate()
    }
    
}
