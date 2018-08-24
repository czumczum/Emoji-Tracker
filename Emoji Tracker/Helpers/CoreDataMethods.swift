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
    var archivedTrackerArray = [Tracker]()
    private var allTrackersArray = [Tracker]()
    
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
    
    func fetchTrackers(on request: NSFetchRequest<Tracker> = Tracker.fetchRequest(), with predicate : NSPredicate) -> [Tracker] {
        var trackerArray = [Tracker]()
        
        request.predicate = predicate
        
        do {
            trackerArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        
        return trackerArray
    }
    
    func fetchTrackerById(on request: NSFetchRequest<Tracker> = Tracker.fetchRequest(), with id: String) -> Tracker {
        
        var tracker : Any = ""
        
        if let objectIDURL = URL(string: id) {
            if let managedObjectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: objectIDURL) {
                do {
                    tracker = try context.existingObject(with: managedObjectID)
                    
                } catch {
                    print("Error fetching data \(error)")
                }
                
            }
        }
        
        return tracker as! Tracker
    }
    
    func deleteTracker(on request: NSFetchRequest<Tracker> = Tracker.fetchRequest(), with tracker : Tracker) {
        
        if (try? context.fetch(request)) != nil {
            context.delete(tracker)
        }
    }
    
    func loadTrackers(on request: NSFetchRequest<Tracker> = Tracker.fetchRequest()) {
        do {
            allTrackersArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        
        sortTrackers()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)!")
        }
    }
    
    private func sortTrackers() {
        archivedTrackerArray = []
        trackerArray = []
        
        for tracker in allTrackersArray {
            if tracker.archived {
                archivedTrackerArray.append(tracker)
            } else {
                trackerArray.append(tracker)
            }
        }
        return
    }
}
