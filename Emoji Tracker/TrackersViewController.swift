//
//  TrackersViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class TrackersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        configureTableView()
        
        coredata.loadTrackers()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    
        trackersTableView?.reloadData()
    }

    // MARK: 3d touch methods
    
    let trackersActions = TrackersActions()
    
    @objc func forceTouchHandler(_ sender: ForceTouchGestureRecognizer) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if sender.state == UIGestureRecognizerState.ended {
            let tapLocation = sender.location(in: self.trackersTableView)
            if let tapIndexPath = self.trackersTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.trackersTableView.cellForRow(at: tapIndexPath) {
                    let tracker = coredata.fetchTrackerById(with: tappedCell.accessibilityIdentifier ?? "")
                    trackersActions.editTracker(tracker: tracker as! Tracker, tableView: self.trackersTableView, controller: self)
                }
            }
        }
    }
    
    //MARK: - Trackers Board
    @IBOutlet weak var trackersTableView: UITableView!
    @IBOutlet weak var addNewTrackerButtonClicked: UIBarButtonItem!
    
    //MARK: TableView DataSource Methods
    struct TrackerList {
        
        var sectionName : String
        var sectionObjects : [Tracker]
    }
    
    var trackersArray = [
        TrackerList(sectionName: "Active", sectionObjects: coredata.trackerArray),
        TrackerList(sectionName: "Archived", sectionObjects: coredata.archivedTrackerArray)
    ]

    func numberOfSections(in tableView: UITableView) -> Int {
        return trackersArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackersArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tracker = trackersArray[indexPath.section].sectionObjects[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        
        cell.textLabel?.text = tracker.title
        cell.detailTextLabel?.text = tracker.emojis
        cell.accessibilityIdentifier = tracker.objectID.uriRepresentation().absoluteString
        
        if tracker.archived {
            cell.backgroundColor = UIColor(red:0.80, green:0.75, blue:0.80, alpha:0.5)
            cell.textLabel?.textColor = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0)
            
            cell.textLabel?.font = cell.textLabel?.font.withSize(17)
            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(20)
        }
        
        let forceTouchGestureRecognizer = ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchHandler))
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            cell.addGestureRecognizer(forceTouchGestureRecognizer)
        } else  {
            // When force touch is not available, remove force touch gesture recognizer.
            // Also implement a fallback if necessary (e.g. a long press gesture recognizer)
            cell.removeGestureRecognizer(forceTouchGestureRecognizer)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trackersArray[section].sectionName
    }
    
    
    //ConfigureTableView
    func configureTableView() {
        trackersTableView?.rowHeight = UITableViewAutomaticDimension
        trackersTableView?.estimatedRowHeight = 120.0
    }

}

