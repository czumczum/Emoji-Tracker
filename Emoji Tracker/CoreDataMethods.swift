//
//  CoreDataMethods.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/7/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import CoreData

let coredata = CoreDataMethods()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class CoreDataMethods {
    
        var trackerArray = [Tracker]()
    
    func loadTrackers(with request: NSFetchRequest<Tracker> = Tracker.fetchRequest(), with predicate: NSPredicate? = nil) {
        do {
            coredata.trackerArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)!")
        }
    }
    
}
