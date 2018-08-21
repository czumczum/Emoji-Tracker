//
//  SwippableTableView.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/16/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwippableTableView: UITableViewController ,SwipeTableViewCellDelegate {
    
    func visibleRect(for tableView: UITableView) -> CGRect? {
        return CGRect.init()
    }
    
    
    // MARK: - TableView DataSource methods
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trackerList = coredata.trackerArray
        let tracker = trackerList[indexPath.row]
        
        //Fetching the current emoji
        guard let start = currentDateObj.now.startOfTheDay() else { fatalError("start date is invalid") }
        guard let end = currentDateObj.now.endOfTheDay() else { fatalError("end date is invalid") }
        
        let titlePredicate = NSPredicate(format: "ANY tracker.title CONTAINS[cd] %@", tracker.title ?? "")
        let datePredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [titlePredicate, datePredicate])
        
        let currentDayDate = coredata.fetchDayData(with: predicate)
        
        switch trackerList[indexPath.row].type {
            
        case "slider":
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderCell
            
            cell.titleLabel?.text = trackerList[indexPath.row].title
            
            if currentDayDate.count != 0 {
                cell.emojiLabel?.text = currentDayDate[0].emoji
            } else {
                cell.emojiLabel?.text = ""
            }
            
            if let maxValue = trackerList[indexPath.row].emojis?.count {
                cell.slider.maximumValue = Float(maxValue) - 0.001
                cell.slider.accessibilityIdentifier = trackerList[indexPath.row].emojis
            }
            
            cell.delegate = self
            
            return cell
            
        case "pick5":
            let cell = tableView.dequeueReusableCell(withIdentifier: "pick5Cell", for: indexPath) as! Pick5Cell
            
            if let emojis = trackerList[indexPath.row].emojis, let buttons = cell.collectionOfButtons {
                cell.titleLabel?.text = trackerList[indexPath.row].title
                
                if currentDayDate.count != 0 {
                    cell.emojiLabel?.text = currentDayDate[0].emoji
                } else {
                    cell.emojiLabel?.text = ""
                }
                
                cell.delegate = self
                
                for button in buttons {
                    guard let index = buttons.index(of: button) else {
                        fatalError("Index of buttons cannot be called")
                    }
                    
                    if index < Array(emojis).count {
                        button.setTitle("\(Array(emojis)[index])", for: [])
                    } else {
                        button.removeFromSuperview()
                    }
                }
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            
            cell.titleLabel?.text = trackerList[indexPath.row].title
            
            if currentDayDate.count != 0 {
                cell.emojiLabel?.text = currentDayDate[0].emoji
            } else {
                cell.emojiLabel?.text = ""
            }
            
            cell.delegate = self
            
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath, with: "delete")
            
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            
            self.updateModel(at: indexPath, with: "edit")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        editAction.backgroundColor = UIColor.blue
        editAction.image = UIImage(named: "edit")
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .reveal
        return options
    }
    
    func updateModel(at indexPath: IndexPath, with action: String) {
        // Methods update data model
    }
}
