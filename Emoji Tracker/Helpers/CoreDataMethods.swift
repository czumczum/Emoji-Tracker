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
    
    //MARK: DayDate filtered to only current day
    func getFilteredDays(date now: Date = currentDateObj.now) -> [DayDate] {
        var dayList = [DayDate]()
        
        let request: NSFetchRequest<DayDate> = DayDate.fetchRequest()
        
        if let start = now.startOfTheDay(), let end = now.endOfTheDay() {
            let predicate: NSPredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
            request.predicate = predicate
        }
        
        do {
            dayList = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        return dayList
    }
    
    func fetchDayData(with predicate: NSPredicate? = nil, with request: NSFetchRequest<DayDate> = DayDate.fetchRequest()) -> [DayDate]{
        
        var daysArray = [DayDate]()
        request.predicate = predicate
        
        do {
            daysArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        
        return daysArray
    }
    
    func loadTrackers(on request: NSFetchRequest<Tracker> = Tracker.fetchRequest(), with predicate: NSPredicate? = nil) {
        do {
            request.predicate = predicate
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
