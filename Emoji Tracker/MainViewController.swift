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
    
    //MARK: - Days StackView
    
    @IBOutlet var todayDateLabel: UILabel!
    @IBOutlet var todayDayLabel: UILabel!
    @IBOutlet var todayEmojiLabel: UILabel!
    
    @IBOutlet var yesterdayEmojiLabel: UILabel!
    @IBOutlet var yesterdayDateLabel: UILabel!
    @IBOutlet var yesterdayDayLabel: UILabel!
    @IBOutlet var yesterdayPanel: UIView!
    
    @IBOutlet var tomorrowEmojiLabel: UILabel!
    @IBOutlet var tomorrowDateLabel: UILabel!
    @IBOutlet var tomorrowDayLabel: UILabel!
    @IBOutlet var todayPanel: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        
        trackerList = realmMethods.loadTrackers()
        
        //adding custom cells' layout
        trackersTableView?.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        trackersTableView?.register(UINib(nibName: "Pick5Cell", bundle: nil), forCellReuseIdentifier: "pick5Cell")
        trackersTableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "inputCell")
       
        //Keyboard scrolling
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Get the current Date
        updateDates()
        updateEmojis()
        
        //tapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.stackViewTapped(_:)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        yesterdayPanel.isUserInteractionEnabled = true
        yesterdayPanel.addGestureRecognizer(tapGesture)
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        trackersTableView?.reloadData()
        
        
    }
    
    //tableViewTapped method for custom Gesture
    @objc func stackViewTapped(_ sender: UITapGestureRecognizer) {
        currentDateObj.turnBackTime()
        updateDates()
        updateEmojis()
    }
    
    //MARK: - Days StackView
    @IBOutlet weak var daysStackView: UIStackView!
    
    //MARK: Add today's date to calendar
    func updateDates(date currentDate: Date = currentDateObj.now) {
        let calendar = Calendar.init(identifier: .gregorian)
        let yesterday = calendar.getYesterdayDate()
        let tomorrow = calendar.getTomorrowDate()
        
        todayDateLabel.text = "\(currentDate.getMonth() ?? ""), \(currentDate.getDayDate() ?? 0)th"
        todayDayLabel.text = currentDate.dayOfTheWeek() ?? ""
        
        yesterdayDateLabel.text = "\(yesterday.getMonth() ?? ""), \(yesterday.getDayDate() ?? 0)th"
        yesterdayDayLabel.text = yesterday.dayOfTheWeek() ?? ""
        
        tomorrowDateLabel.text = "\(tomorrow.getMonth() ?? ""), \(tomorrow.getDayDate() ?? 0)th"
        tomorrowDayLabel.text = tomorrow.dayOfTheWeek() ?? ""
        
        //TODO: delete after development
        print(currentDate)
        print(yesterday as Any)
        print(tomorrow as Any)
    }
    
    //MARK: DayDate filtered to only current day
    func getFilteredDays(date now : Date = currentDateObj.now) -> Results<DayDate>? {
        let daysList = realm.objects(DayDate.self)
        if let start = now.startOfTheDay(), let end = now.endOfTheDay() {
            let predicate: NSPredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
            return daysList.filter(predicate)
            
        }
        return daysList
    }
    
    //MARK: Add current emojis to calendar
    func updateEmojis(date currentDate : Date = currentDateObj.now) {
        //today
        if let currentDayDate = getFilteredDays(date: currentDate) {
            var emojiList = ""
            for dayDate in currentDayDate {
                emojiList += "\(dayDate.emoji)"
            }
            todayEmojiLabel.text = emojiList
        }
        
        let calendar = Calendar(identifier: .gregorian)
        // tomorrow
        if let tomorrowDayDate = getFilteredDays(date: calendar.getTomorrowDate()) {
            var emojiList = ""
            for dayDate in tomorrowDayDate {
                emojiList += "\(dayDate.emoji)"
            }
            tomorrowEmojiLabel.text = emojiList
        }
        
        //yesterday
        if let yesterdayDayDate = getFilteredDays(date: calendar.getYesterdayDate()) {
            var emojiList = ""
            for dayDate in yesterdayDayDate {
                emojiList += "\(dayDate.emoji)"
            }
            yesterdayEmojiLabel.text = emojiList
        }
    }

    
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
    
    //MARK: Saving the DayData from trackers & user's answers
    
    func saveNewDayDate(date currentDate: Date = currentDateObj.now, emoji : String, tracker : String) {
        
        let dayDate = DayDate()
        dayDate.date = currentDate
        addOrUpdateEmoji(emoji: emoji, date: currentDate)
//        realmMethods.saveToRealm(with: dayDate)
    }
    
    func addOrUpdateEmoji(emoji : String, date : Date) {
         let emojiObject = realm.objects(Emoji.self).filter(NSPredicate(format: "symbol CONTAINS[cd] %@", emoji ))
            print(emojiObject)
    }

}

