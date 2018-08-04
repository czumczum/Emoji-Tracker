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
    
    func turnBackTime() {
        let calendar = Calendar(identifier: .gregorian)
        now = calendar.getYesterdayDate()
    }
    
    func backToTheFuture() {
        let calendar = Calendar(identifier: .gregorian)
        now = calendar.getTomorrowDate()
    }
    
}
