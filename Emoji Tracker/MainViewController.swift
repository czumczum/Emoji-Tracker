//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    let realmMethods = RealmMethods()
    
    var trackerList: Results<Tracker>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("date",Date(),"date")
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
//        configureTableView()
        
        trackerList = realmMethods.loadTrackers()
        
        //adding custom cells' layout
        trackersTableView?.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        trackersTableView?.register(UINib(nibName: "Pick5Cell", bundle: nil), forCellReuseIdentifier: "pick5Cell")
        trackersTableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "inputCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        trackersTableView?.reloadData()
        
    }
    
    //MARK: - Days StackView

    @IBOutlet var todayDateLabel: UILabel!
    @IBOutlet var todayDayLabel: UILabel!
    @IBOutlet var todayEmojiLabel: UILabel!
    
    
 
    //MARK: Days StackView
    @IBOutlet weak var daysStackView: UIStackView!
       //MARK: Add today's date to calendar
    
    //MARK: - Table View
    
    //MARK: Scroll the view for keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            trackersTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
            trackersTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    //MARK: Trackers TableView
    @IBOutlet var trackersTableView: UITableView!
    
    let numberOfCellsPerRow: CGFloat = 2
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerList?.count ?? 0
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch trackerList?[indexPath.row].type {
        case "slider":
                let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderCell
                
                cell.titleLabel?.text = trackerList?[indexPath.row].name
                cell.emojiLabel?.text = trackerList?[indexPath.row].emojis
                
                return cell
        case "pick5":
            let cell = tableView.dequeueReusableCell(withIdentifier: "pick5Cell", for: indexPath) as! Pick5Cell
            
            cell.titleLabel?.text = trackerList?[indexPath.row].name
            cell.emojiLabel?.text = trackerList?[indexPath.row].emojis
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            
            cell.titleLabel?.text = trackerList?[indexPath.row].name
            cell.emojiLabel?.text = trackerList?[indexPath.row].emojis
            
            return cell
        }
    }

}

