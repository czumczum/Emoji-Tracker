//
//  RealmMethods.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/31/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import RealmSwift

class RealmMethods {
    let realm = try! Realm()
    
    func saveToRealm(with object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error saving context, \(error)!")
        }
    }
    
    func deleteFromRealm(with object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting an item \(error)")
        }
    }
    
    func loadTrackers() -> Results<Tracker> {
        return realm.objects(Tracker.self)
    }
    
}


