//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
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
        updateAllPanels()
        enableBackButton(hidden: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        
        coredata.loadTrackers()
        
        //adding custom cells' layout
        trackersTableView?.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        trackersTableView?.register(UINib(nibName: "Pick5Cell", bundle: nil), forCellReuseIdentifier: "pick5Cell")
        trackersTableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "inputCell")
        
        //Keyboard scrolling
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Get the current date's data
        currentDateObj.setYesterdayAndTomorrow()
        updateAllPanels()
        
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
    
    //MARK: - Trackers TableView
    @IBOutlet var trackersTableView: UITableView!
    
    let numberOfCellsPerRow: CGFloat = 2
    
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
            updateAllPanels()
            enableBackButton(hidden: false)
        }
    }
    
    //MARK: Shortcut function
    func updateAllPanels() {
        //today
        updateDates()
        updateEmojis()
        //yesterday
        updateDates(date: currentDateObj.yesterday)
        updateEmojis(date: currentDateObj.yesterday)
        //tomorrow
        updateEmojis(date: currentDateObj.tomorrow)
        updateDates(date: currentDateObj.tomorrow)
        
        return
    }
    
    //MARK: Add today's date to calendar
    func updateDates(date currentDate: Date = currentDateObj.now) {

        switch currentDate {
        case currentDateObj.yesterday:
            yesterdayDateLabel.text = "\(currentDate.getMonth() ?? ""), \(currentDate.getDayDate() ?? 0)th"
            yesterdayDayLabel.text = currentDate.dayOfTheWeek() ?? ""
        case currentDateObj.now:
            todayDateLabel.text = "\(currentDate.getMonth() ?? ""), \(currentDate.getDayDate() ?? 0)th"
            todayDayLabel.text = currentDate.dayOfTheWeek() ?? ""
        default:
            tomorrowDateLabel.text = "\(currentDate.getMonth() ?? ""), \(currentDate.getDayDate() ?? 0)th"
            tomorrowDayLabel.text = currentDate.dayOfTheWeek() ?? ""
        }
        
        return
    }
    
    //MARK: DayDate filtered to only current day
    func getFilteredDays(date now : Date = currentDateObj.now) -> [DayDate] {
        var dayList = [DayDate]()
        
        let request: NSFetchRequest<DayDate> = DayDate.fetchRequest()
        
        if let start = now.startOfTheDay(), let end = now.endOfTheDay() {
            let predicate: NSPredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
            request.predicate = predicate
        }
        
        do {
            dayList = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        return dayList
    }
    
    //MARK: Add current emojis to calendar
    func updateEmojis(date currentDate : Date = currentDateObj.now) {
//        today
        let currentDayDate = getFilteredDays(date: currentDate)
        var emojiList = [Emoji]()
        var emojiString = ""
        
        if currentDayDate.count > 0 {
            guard let today = currentDayDate[0].date else {
                fatalError("currentDatDate object has no .date")
                
            }
            let datePredicate = NSPredicate(format: "ANY date.date == %@", today as CVarArg)
            let request: NSFetchRequest<Emoji> = Emoji.fetchRequest()
            request.predicate = datePredicate
            
            do {
                emojiList = try context.fetch(request)
            } catch {
                print("Error fetching data \(error)")
            }
            
        }
        
        for emoji in emojiList {
            emojiString += emoji.symbol ?? ""
        }
        switch currentDate {
        case currentDateObj.now:
            self.todayEmojiLabel?.text = emojiString
        case currentDateObj.yesterday:
            self.yesterdayEmojiLabel?.text = emojiString
        default:
            self.tomorrowEmojiLabel?.text = emojiString
        }
    }
    
    func updateEmojiFrequency() {
        
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coredata.trackerArray.count
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trackerList = coredata.trackerArray
        
        switch trackerList[indexPath.row].type {
        case "slider":
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderCell
            
            cell.titleLabel?.text = trackerList[indexPath.row].title
            cell.emojiLabel?.text = trackerList[indexPath.row].emojis
            
            return cell
        case "pick5":
            let cell = tableView.dequeueReusableCell(withIdentifier: "pick5Cell", for: indexPath) as! Pick5Cell
            
            if let emojis = trackerList[indexPath.row].emojis, let buttons = cell.collectionOfButtons {
                cell.titleLabel?.text = trackerList[indexPath.row].title
                cell.emojiLabel?.text = emojis
                
                cell.delegate = self
                
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
            
            cell.titleLabel?.text = trackerList[indexPath.row].title
            cell.emojiLabel?.text = trackerList[indexPath.row].emojis
            
            return cell
        }
    }
    

    
}

extension MainViewController: clickDelegate {
    
    //MARK: - Saving the DayData from trackers & user's answers
    
    //MARK: Cell delegate mothods
    func createNewRecord(emoji: String, tracker: String) {
        
        // fetch current DayDate
        // fetch current Emoji
        // fetch current Tracker
        
        // check if there's any DayDate
        // if so ->
            // check if there's such Tracker for today with setTrackerData
            // Func will add current DayData into Tracker if necessary or do nothing if not
            // as return will be a bool
                // if false ->
                    // fire addOrUpdateEmoji
                    // add Tracker and Emoji into Date
                // if true ->
                    // fire undoSetEmoji & addOrUpdateEmoji for the new one
                    // change Emoji for this Tracker in current DayDate
        
        // if not -> create method
            // create new DayData
            // fire setTrackerData -->> it will be always false
            // fire addOrUpdate Emoji
            // add Tracker & Emoji into new DayDate
        
        // save context
    }
    
    func createNewDayDate(emoji : String, tracker : String) {
        
        let dayDateArray = getFilteredDays(date: currentDateObj.now)
        var dayDate : DayDate
        
        if dayDateArray.count == 0 {
            dayDate = DayDate(context: context)
            dayDate.date = currentDateObj.now
            
            let emoji = addOrUpdateEmoji(emoji: emoji, date: dayDate)
            dayDate.emoji = [emoji]
        } else {
            dayDate = dayDateArray[0]
            let emoji = addOrUpdateEmoji(emoji: emoji, date: dayDate)
            
            if let emojiArray = dayDate.emoji {
                let mutableEmoji = emojiArray.mutableCopy() as! NSMutableOrderedSet
                mutableEmoji.add(emoji)
                dayDate.emoji = mutableEmoji.copy() as? NSOrderedSet
            }
        }
        
        coredata.saveContext()
    }
    
    func addOrUpdateEmoji(emoji : String, date : DayDate) -> Emoji {
        let emojiArray = coredata.fetchEmoji(with: emoji)
        
        if emojiArray.count == 0 {
            
            let newEmoji = Emoji(context: context)
            newEmoji.symbol = emoji
            newEmoji.frequency = 1
            newEmoji.date = [date]
            
            return newEmoji
            
        } else {
            let currentEmoji = emojiArray[0]
            // Updating Emoji frequency
            currentEmoji.frequency += 1
            if let datesArray = currentEmoji.date {
                let mutableDates = datesArray.mutableCopy() as! NSMutableSet
                mutableDates.add(date)
                currentEmoji.date = mutableDates.copy() as? NSSet
            }
            return emojiArray[0]
            
        }
    }
    
    func undoSetEmoji() {
        // Was called only if user changed his mind and set another emoji for current day & tracker
        // fetch emoji from DB
        // delete current DayDate
        // subtrack 1 from frequency
    }
    
    func setTrackerData(title: String, date: DayDate) -> Bool {
        let tracker = coredata.fetchTracker(tracker: title, date: date)
        
        if tracker.count == 0 {
            // there's no tracker data for current day
            // save data into tracker
            // give true for data method
        } else {
            // data for this day & this tracker was set before
            // don't save data into tracker
            // give false for data method
        }
        
        return false
    }
    
}

