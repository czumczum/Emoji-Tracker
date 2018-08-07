//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trackerList = [Tracker]()
    
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
    @IBOutlet var tomorrowPanel: UIView!
    
    //MARK: Navigation items
    @IBOutlet var backToTodayButton: UIBarButtonItem!
    @IBAction func backToTodayButtonClicked(_ sender: UIBarButtonItem) {
        currentDateObj.restoreTimeLine()
        updateDates()
        updateEmojis()
        enableBackButton(hidden: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        
//        trackerList = realmMethods.loadTrackers()
        
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
        let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(self.stackViewTapped(_:)))
        tapGestureBack.delegate = self as? UIGestureRecognizerDelegate
        yesterdayPanel.isUserInteractionEnabled = true
        yesterdayPanel.addGestureRecognizer(tapGestureBack)
        
        let tapGestureForth = UITapGestureRecognizer(target: self, action: #selector(self.stackViewTapped(_:)))
        tapGestureForth.delegate = self as? UIGestureRecognizerDelegate
        tomorrowPanel.isUserInteractionEnabled = true
        tomorrowPanel.addGestureRecognizer(tapGestureForth)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        
        //Trackers' table view methods
        trackersTableView?.reloadData()
        
        
    }
    
    //MARK: - Navigation controller "Back to today" button
    func enableBackButton(hidden : Bool) {
        if hidden {
            backToTodayButton.isEnabled = false
            backToTodayButton.tintColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            backToTodayButton.isEnabled = true
            backToTodayButton.tintColor = UIColor(displayP3Red: 0.290196, green: 0.564706, blue: 0.886275, alpha: 1)
        }
    }
    
    //MARK: - Days StackView
    @IBOutlet weak var daysStackView: UIStackView!
    
    //MARK: Method for custom Gesture
    @objc func stackViewTapped(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            switch tag {
            case 1:
                currentDateObj.backToTheFuture()
            default:
                currentDateObj.turnBackTime()
            }
            updateDates()
            updateEmojis()
            enableBackButton(hidden: false)
        }
    }
    
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
    }
    
    //MARK: DayDate filtered to only current day
    func getFilteredDays(date now : Date = currentDateObj.now) -> [DayDate] {
        let daysList = [DayDate]()
        if let start = now.startOfTheDay(), let end = now.endOfTheDay() {
            let predicate: NSPredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
//            return daysList.filter(predicate)
            return daysList
            
        }
        return daysList
    }
    
    //MARK: Add current emojis to calendar
    func updateEmojis(date currentDate : Date = currentDateObj.now) {
        //today
//        if let currentDayDate = getFilteredDays(date: currentDate) {
//            var emojiList = ""
//            for dayDate in currentDayDate {
//                emojiList += "\(dayDate.emoji[0].symbol)"
//                print(dayDate.emoji[0].symbol)
//            }
//            todayEmojiLabel?.text = emojiList
//            print(todayEmojiLabel)
//        }
        
        let calendar = Calendar(identifier: .gregorian)
        // tomorrow
//        if let tomorrowDayDate = getFilteredDays(date: calendar.getTomorrowDate()) {
//            var emojiList = ""
//            for dayDate in tomorrowDayDate {
//                emojiList += "\(dayDate.emoji)"
//            }
//            tomorrowEmojiLabel?.text = emojiList
//        }
        
        //yesterday
//        if let yesterdayDayDate = getFilteredDays(date: calendar.getYesterdayDate()) {
//            var emojiList = ""
//            for dayDate in yesterdayDayDate {
//                emojiList += "\(dayDate.emoji)"
//            }
//            yesterdayEmojiLabel?.text = emojiList
//        }
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
        return trackerList.count
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch trackerList[indexPath.row].type {
        case "slider":
                let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderCell
                
                cell.titleLabel?.text = trackerList[indexPath.row].name
                cell.emojiLabel?.text = trackerList[indexPath.row].emojis
                
                return cell
        case "pick5":
            let cell = tableView.dequeueReusableCell(withIdentifier: "pick5Cell", for: indexPath) as! Pick5Cell
            
            if let emojis = trackerList[indexPath.row].emojis, let buttons = cell.collectionOfButtons {
                cell.titleLabel?.text = trackerList[indexPath.row].name
                cell.emojiLabel?.text = emojis
                
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
            
            cell.titleLabel?.text = trackerList[indexPath.row].name
            cell.emojiLabel?.text = trackerList[indexPath.row].emojis
            
            return cell
        }
    }
    
    //MARK: - Saving the DayData from trackers & user's answers

    func createNewDayDate(emoji : String, tracker : String) {
        
        let dayDate = DayDate()
        dayDate.date = currentDateObj.now
        
        addOrUpdateEmoji(emoji: emoji, date: dayDate)
//        realmMethods.saveToRealm(with: dayDate)
        print(tracker, emoji)
    }
    
    func addOrUpdateEmoji(emoji : String, date : DayDate) {
//        let emojiObject = realm.objects(Emoji.self).filter(NSPredicate(format: "symbol CONTAINS[cd] %@", emoji ))
        
//        if emojiObject.count == 0 {
//
//            let newEmoji = Emoji()
//            newEmoji.symbol = emoji
//            newEmoji.frequency += 1
//
//            //Saving DayDate into Emoji
////            newEmoji.date.append(date)
//            
////            realmMethods.saveToRealm(with: newEmoji)
//
//        } else {
//            // Updating Emoji frequency
//            do {
////                try self.realm.write {
////                    emojiObject[0].frequency += 1
////                    emojiObject[0].date.append(date)
//                }
//            } catch {
//                print("Error updatin an item \(error)")
//            }
//        }
//        updateEmojis()
        print(self.yesterdayEmojiLabel)
    }
    
    func updateEmojiFrequency() {
        
    }

}

