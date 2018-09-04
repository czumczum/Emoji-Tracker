//
//  TrackersViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class TrackersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var toolTipView: ToolTipView!
    private var trackerforUIMenu: Tracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        configureTableView()
        
        coredata.loadTrackers()
        refreshTrackersArray()
        
        toolTipView = ToolTipView()
        
        //MARK: Single tap handler
        let tapGestureTracker = UITapGestureRecognizer(target: self, action: #selector(self.trackerCellTapped(_:)))
        tapGestureTracker.delegate = self as? UIGestureRecognizerDelegate
        trackersTableView.isUserInteractionEnabled = true
        trackersTableView.addGestureRecognizer(tapGestureTracker)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    
        trackersTableView?.reloadData()
    }

    // MARK: - touch methods
    
    //MARK: Tapped cell
    @objc func trackerCellTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let tapLocation = sender.location(in: self.trackersTableView)
            if let tapIndexPath = self.trackersTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.trackersTableView.cellForRow(at: tapIndexPath) {
                    let tracker = coredata.fetchTrackerById(with: tappedCell.accessibilityIdentifier ?? "")
                    
                    self.performSegue(withIdentifier: "openTrackerCalendar", sender: tracker)
                }
            }
        }
    }
    
    //MARK: Force touch
    let trackersActions = TrackersActions()
    
    @objc func forceTouchHandler(_ sender: ForceTouchGestureRecognizer) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if sender.state == UIGestureRecognizerState.ended {
            let absoluteLocation = sender.location(in: self.view)
            let tapLocation = sender.location(in: self.trackersTableView)
            if let tapIndexPath = self.trackersTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.trackersTableView.cellForRow(at: tapIndexPath) {
                    let tracker = coredata.fetchTrackerById(with: tappedCell.accessibilityIdentifier ?? "")
                    //For UIMEnu to know what tracker was tapped
                    trackerforUIMenu = tracker
                    openToolTip(location: absoluteLocation)
                }
            }
        }
    }
    
    //MARK: - Segue info to pass (for single tap)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openTrackerCalendar" {
            let calendar = segue.destination as! CalendarView
            let tracker = sender as? Tracker
            calendar.sender = tracker
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
    
    var trackersArray = [TrackerList]()
    
    func refreshTrackersArray() {
        trackersArray = [
            TrackerList(sectionName: "Active", sectionObjects: coredata.trackerArray),
            TrackerList(sectionName: "Archived", sectionObjects: coredata.archivedTrackerArray)
        ]
    }

    //MARK: - TableView
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
        } else {
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor(red: 0.371, green: 0.371, blue: 0.371, alpha: 1.0)
            cell.textLabel?.font = cell.textLabel?.font.withSize(20)
            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(25)
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
    
    //MARK: - UIMenuController as Tooltip
    func openToolTip(location: CGPoint) {
        toolTipView.center = location
        toolTipView.backgroundColor = UIColor(red: 124.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 0.8)
        toolTipView.layer.cornerRadius = 4;
        toolTipView.layer.masksToBounds = true
        
        self.view.addSubview(toolTipView)

        toolTipView.becomeFirstResponder()
        
        // Set up the shared UIMenuController
        let menu = UIMenuController.shared
        menu.arrowDirection = .default
        menu.setTargetRect(toolTipView.frame, in: self.view)
        
        var archiveStatus = "Archive"
        if (trackerforUIMenu?.archived)! {
            archiveStatus = "Activate"
        }
        
        // UIMenuController methods
        let editItem = UIMenuItem(title: "Edit", action: #selector(editTapped))
        let archiveItem = UIMenuItem(title: archiveStatus, action: #selector(archiveTapped))
        let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteTapped))
        
        UIMenuController.shared.menuItems = [editItem, archiveItem, deleteItem]
        
        menu.setMenuVisible(true, animated: true)
        
    }
    
    @objc func archiveTapped() {
        if let tracker = trackerforUIMenu {
            
            tracker.archived = !tracker.archived
            coredata.saveContext()
            
            coredata.loadTrackers()
            //For a proper sorting of trackers they need to be sorted before the tableView is reloaded
            refreshTrackersArray()
            
            trackersTableView.reloadData()
        }
    }
    
    @objc func deleteTapped() {
        if let tracker = trackerforUIMenu {
            coredata.deleteTracker(with: tracker)

            coredata.loadTrackers()
            refreshTrackersArray()
            trackersTableView.reloadData()
        }
    }
    
    @objc func editTapped() {
        if trackerforUIMenu != nil {
            trackersActions.editTracker(tracker: trackerforUIMenu!, tableView: trackersTableView, controller: self)
        }
    }

}

