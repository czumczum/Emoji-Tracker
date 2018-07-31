//
//  Date.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/31/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import Foundation
import RealmSwift

class DayDate: Object {
    @objc dynamic var date : Date = Date()
    
    var emoji = List<Emoji>()
    var tracker = List<Tracker>()
    
    //TODO: Emoji:Tracker
}
