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
    
    //Stored in local time
    @objc dynamic var date : Date = Date()

    var emoji = LinkingObjects(fromType: Emoji.self, property: "date")
    var tracker = LinkingObjects(fromType: Tracker.self, property: "date")

}
