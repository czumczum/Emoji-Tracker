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
    func createNewDayDate(emoji : String, tracker : String) {
        
        let dayDateArray = getFilteredDays(date: currentDateObj.now)
        
        if dayDateArray.count == 0 {
            
            let dayDate = DayDate(context: context)
            dayDate.date = currentDateObj.now
            
            let emoji = addOrUpdateEmoji(emoji: emoji, date: dayDate)
            dayDate.emoji = [emoji]
            
        } else {
            let dayDate = dayDateArray[0]
        }
        
        coredata.saveContext()
        print(tracker, emoji)
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
            // Updating Emoji frequency
            emojiArray[0].frequency += 1
            let datesArray = emojiArray[0].date
            print(datesArray)
            
            return emojiArray[0]
            
        }
        
    }
    
}

