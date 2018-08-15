//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

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
    
    //MARK: - Menu items and functions
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        if menuWidth.constant == 0 {
            viewLeadingConst.constant = 100
            viewTrailingConst.constant = -100
            menuWidth.constant = 100
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            viewLeadingConst.constant = 0
            viewTrailingConst.constant = 0
            menuWidth.constant = 0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBOutlet var viewLeadingConst: NSLayoutConstraint!
    @IBOutlet var viewTrailingConst: NSLayoutConstraint!
    @IBOutlet var menuWidth: NSLayoutConstraint!
    
    func openTabmenu() {
        viewLeadingConst.constant = 100
        viewTrailingConst.constant = -100
        menuWidth.constant = 100
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
            trackersTableView.reloadData()
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
    
    //MARK: Add current emojis to calendar
    func updateEmojis(date currentDate : Date = currentDateObj.now) {
        let currentDayDate = coredata.getFilteredDays(date: currentDate)
        var emojiString = ""

        for log in currentDayDate {
            emojiString += log.emoji ?? ""
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
}


//MARK: - Table View

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let tracker = trackerList[indexPath.row]
        
        //Fetching the current emoji
        guard let start = currentDateObj.now.startOfTheDay() else { fatalError("start date is invalid") }
        guard let end = currentDateObj.now.endOfTheDay() else { fatalError("end date is invalid") }
        
        let titlePredicate = NSPredicate(format: "ANY tracker.title CONTAINS[cd] %@", tracker.title ?? "")
        let datePredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [titlePredicate, datePredicate])
        
        let currentDayDate = coredata.fetchDayData(with: predicate)
        
        switch trackerList[indexPath.row].type {
            
        case "slider":
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderCell
            
            cell.titleLabel?.text = trackerList[indexPath.row].title
            
            if currentDayDate.count != 0 {
            cell.emojiLabel?.text = currentDayDate[0].emoji
            } else {
                cell.emojiLabel?.text = ""
            }
            
            if let maxValue = trackerList[indexPath.row].emojis?.count {
                cell.slider.maximumValue = Float(maxValue) - 0.001
                cell.slider.accessibilityIdentifier = trackerList[indexPath.row].emojis
            }
            
            cell.delegate = self
            
            return cell
            
        case "pick5":
            let cell = tableView.dequeueReusableCell(withIdentifier: "pick5Cell", for: indexPath) as! Pick5Cell
            
            if let emojis = trackerList[indexPath.row].emojis, let buttons = cell.collectionOfButtons {
                cell.titleLabel?.text = trackerList[indexPath.row].title
                
                if currentDayDate.count != 0 {
                    cell.emojiLabel?.text = currentDayDate[0].emoji
                } else {
                    cell.emojiLabel?.text = ""
                }
                
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
            
            if currentDayDate.count != 0 {
                cell.emojiLabel?.text = currentDayDate[0].emoji
            } else {
                cell.emojiLabel?.text = ""
            }
            
             cell.delegate = self
            
            return cell
        }
    }
}

//MARK: - Cell delegate mothods

extension MainViewController: clickDelegate {
    
    //MARK: Saving the DayData from trackers & user's answers
    func createNewRecord(emoji: String, tracker: String) {
        
        guard let start = currentDateObj.now.startOfTheDay() else { fatalError("start date is invalid") }
        guard let end = currentDateObj.now.endOfTheDay() else { fatalError("end date is invalid") }
        
        let titlePredicate = NSPredicate(format: "ANY tracker.title CONTAINS[cd] %@", tracker)
        let datePredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [titlePredicate, datePredicate])
        let currentDayDate = coredata.fetchDayData(with: predicate)
        
        if currentDayDate.count == 0 {
            let newDayDate = DayDate(context: context)
            newDayDate.date = currentDateObj.now
            newDayDate.emoji = emoji
            newDayDate.dayOfTheWeek = currentDateObj.now.getDayNumber()
            newDayDate.tracker = setTrackerData(title: tracker, date: newDayDate)
        } else {
            currentDayDate[0].emoji = emoji
        }
        
        coredata.saveContext()
        updateEmojis()
    }
    
    func setTrackerData(title: String, date: DayDate) -> Tracker {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        let trackersArray = coredata.fetchTrackers(with: predicate)

        guard let trackerDates = trackersArray[0].date else {
            fatalError("there's no obiect 'date' in this tracker")
        }

        if trackerDates.count > 0 {
               let mutableDates = trackerDates.mutableCopy() as! NSMutableOrderedSet
               mutableDates.add(date)
               trackersArray[0].date = mutableDates.copy() as? NSOrderedSet
        } else {
                trackersArray[0].date = [date]
        }
        
        return trackersArray[0]
    }
    
}
