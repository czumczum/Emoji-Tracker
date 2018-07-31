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
    @objc dynamic var date : String = ""
    
    var emoji = List<Emoji>()
    var tracker = List<Tracker>()
    
    //TODO: Emoji:Tracker pair
    
//    @objc dynamic var date : String = ""
//    @objc dynamic var emoji : String = ""
//    @objc dynamic var tracker : String = ""
}
