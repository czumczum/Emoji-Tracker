//
//  Tracker.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import Foundation
import RealmSwift

class Tracker: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var emojis : String = ""
    @objc dynamic var archived : Bool = false
    @objc dynamic var type : String = ""
    
    //TODO: Most frequently used emoji
    
    var category = LinkingObjects(fromType: Category.self, property: "tracker")
}
