//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    let realmMethods = RealmMethods()
    
    var trackerList: Results<Tracker>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
//        configureTableView()
        
        trackerList = realmMethods.loadTrackers()
        
        //adding custom cells' layout
        trackersTableView.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        trackersTableView.register(UINib(nibName: "Pick5Cell", bundle: nil), forCellReuseIdentifier: "pick5Cell")
//        trackersTableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        trackersTableView?.reloadData()
        
    }


    //MARK: - Main Board
    //MARK: Days StackView
    @IBOutlet weak var daysStackView: UIStackView!
    
    //MARK: Trackers TableView
    @IBOutlet var trackersTableView: UITableView!
    
    let numberOfCellsPerRow: CGFloat = 2
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerList?.count ?? 0
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if trackerList?[indexPath.row].type == "slider" {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! TrackDetailCell
        
        cell.titleLabel?.text = trackerList?[indexPath.row].name
        cell.emojiLabel?.text = trackerList?[indexPath.row].emojis
        
        return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pick5Cell", for: indexPath) as! TrackDetailCell
            
            cell.trackerNameLabel2.text = trackerList?[indexPath.row].name
            cell.emojiLabel2?.text = trackerList?[indexPath.row].emojis
            
            return cell
            
        }
    }
    
    
    
    //MARK: - Stats Swipping pages
    
    @IBAction func dismissStatsButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

