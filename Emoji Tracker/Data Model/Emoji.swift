//
//  Emoji.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/31/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import Foundation
import RealmSwift

class Emoji: Object {
    @objc dynamic var symbol : String = ""
    @objc dynamic var frequency : Int = 0
    
    //TODO: Day when the emoji is used the most
    
    var date = List<DayDate>()

}

