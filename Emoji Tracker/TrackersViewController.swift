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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
