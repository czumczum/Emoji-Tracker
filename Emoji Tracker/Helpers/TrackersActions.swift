//
//  TrackersActions.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/21/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class TrackersActions {
    func editTracker(tracker: Tracker, tableView trackersTableView: UITableView, controller: UIViewController) {
        let menu = UIAlertController(title: "Edit Tracker", message: nil, preferredStyle: .actionSheet)
        
        // Name change
        let changeNameAction = UIAlertAction(title: "Change Name", style: .default) { (action) in
            
            // Alert-prompt to enter a new name
            let alert = UIAlertController(title: "Edit name", message: "", preferredStyle: .alert)
            var textField = UITextField()
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                // Updating Category with a new name
                if let newName = textField.text {
                    tracker.title = newName
                    coredata.saveContext()
                }
                trackersTableView.reloadData()
            })
            
            alert.addAction(action)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New name"
                textField = alertTextField
            }
            controller.present(alert, animated: true, completion: nil)
            
        }
        // Emojis change
        let changeEmojiAction = UIAlertAction(title: "Change Emojis", style: .default) { (action) in
            
            // Alert-prompt to enter a new name
            let alert = UIAlertController(title: "Edit emojis", message: "", preferredStyle: .alert)
            var textField = UITextField()
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                // Updating Category with a new name
                if let newEmojis = textField.text {
                    tracker.emojis = newEmojis
                    coredata.saveContext()
                }
                trackersTableView.reloadData()
            })
            
            alert.addAction(action)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New emojis"
                textField = alertTextField
                textField.text = tracker.emojis
            }
            controller.present(alert, animated: true, completion: nil)
            
        }
        
        // Type change
        let changeTypeAction = UIAlertAction(title: "Change Type of Tracker", style: .default, handler: { (action) in
            let changeTypeAlert = UIAlertController (title: "Change type of Tracker", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            
            //preset keyword as button in alert controller
            let bt1 = UIAlertAction(title: "Slider", style: UIAlertActionStyle.default){
                (action) in
                tracker.type = "slider"
                coredata.saveContext()
                trackersTableView.reloadData()
            }
            
            changeTypeAlert.addAction(bt1)
            
            //preset keyword as button in alert controller
            let bt2 = UIAlertAction(title: "Pick 5", style: UIAlertActionStyle.default){
                (action) in
                tracker.type = "pick5"
                coredata.saveContext()
                trackersTableView.reloadData()
                
            }
            
            changeTypeAlert.addAction(bt2)
            
            //preset keyword as button in alert controller
            let bt3 = UIAlertAction(title: "Input", style: UIAlertActionStyle.default){
                (action) in
                tracker.type = "input"
                coredata.saveContext()
                trackersTableView.reloadData()
            }
            
            changeTypeAlert.addAction(bt3)
            
            //Create Cancel Action
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            changeTypeAlert.addAction(cancel)
            
            //Present Alert Controller
            controller.present(changeTypeAlert, animated:true, completion: nil)
        })
        
        
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        menu.addAction(changeNameAction)
        menu.addAction(changeEmojiAction)
        menu.addAction(changeTypeAction)
        menu.addAction(cancelAction)
        
        controller.present(menu, animated: true)
    }
}
