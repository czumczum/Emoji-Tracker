//
//  TrackersViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import CoreData

class TrackersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    let realmMethods = RealmMethods()
    
    var trackerList: Results<Tracker>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        configureTableView()
        
        trackerList = realmMethods.loadTrackers()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerList?.count ?? 0
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        
        cell.textLabel?.text = trackerList?[indexPath.row].name
        cell.detailTextLabel?.text = trackerList?[indexPath.row].emojis
        
        return cell
    }
    
    
    //ConfigureTableView
    func configureTableView() {
        trackersTableView?.rowHeight = UITableViewAutomaticDimension
        trackersTableView?.estimatedRowHeight = 120.0
    }

}
