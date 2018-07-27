//
//  TrackersViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class TrackersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trackerList : [Trackers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        configureTableView()
        
        let firstTracker = Trackers()
        firstTracker.name = "My dog"
        firstTracker.emojis = "😂🙂😍🤓😱"
        trackerList.append(firstTracker)
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
        print(trackerList.count)
        return trackerList.count
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view is comming")
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! UITableViewCell
        
        let cell = UITableViewCell()
        cell.textLabel?.text = trackerList[indexPath.row].name
        cell.detailTextLabel?.text = trackerList[indexPath.row].emojis
        
        return cell
    }
    
    
    //ConfigureTableView
    func configureTableView() {
        trackersTableView?.rowHeight = UITableViewAutomaticDimension
        trackersTableView?.estimatedRowHeight = 120.0
    }

}
