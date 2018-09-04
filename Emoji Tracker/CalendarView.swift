//
//  CalendarView.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/29/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarView: UIViewController {
    let dateFormatter = DateFormatter().getCalendarFormatted()
    
    var sender: Tracker?
    
    @IBOutlet var collectionView: JTAppleCalendarView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var trackerTitleLabel: UILabel!
    @IBOutlet var trackerEmojisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Delegates and Custom cells added to VC
        collectionView.calendarDelegate = self
        collectionView.calendarDataSource = self
        
        collectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
        
        setUpCalendarView()
        
        //MARK: tapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(tapGesture)
        
    }
    
    func setUpCalendarView() {
        collectionView.minimumLineSpacing = 1
        collectionView.minimumInteritemSpacing = 1
    
        //MARK: Setup for Tracker CalendarView -> header
        if sender != nil {
            trackerTitleLabel.text = sender?.title
            trackerEmojisLabel.text = sender?.emojis
        }
        
    }
    
    //MARK: - Tap gestuer handler
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let tapLocation = sender.location(in: self.collectionView)
            if let tapIndexPath = self.collectionView.indexPathForItem(at: tapLocation) {
                if let tappedCell = self.collectionView.cellForItem(at: tapIndexPath) {
                   let cell = tappedCell as! CalendarCell
                    
                    //After tap on cell the date changes to date from cell and CalendarView is dismissed
                    currentDateObj.now = cell.date
                    self.performSegue(withIdentifier: "mainStoryBoard", sender: self)
                }
            }
        }
    }
    
}

extension CalendarView: JTAppleCalendarViewDataSource {
    
    //MARK: - Calendar configuration
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let myStartDate = dateFormatter.string(from: currentDateObj.oneYearBack())
        let myEndDate = dateFormatter.string(from: currentDateObj.oneYearForward())
        
        guard let startDate = dateFormatter.date(from: myStartDate) else {
            fatalError("Start date coudn't be retreived")
        }
        guard let endDate = dateFormatter.date(from: myEndDate) else {
            fatalError("End date coudn't be retreived")
        }
        
        calendar.scrollToDate(currentDateObj.now, animateScroll: false)
        
        //MARK: Update month label after first appear
        calendar.visibleDates { (visibleDates) in
            self.updateCalendarHeader(dates: visibleDates)
        }
        
        calendar.scrollingMode = .stopAtEachSection
        
        let parameters = ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .monday
        )
        return parameters
    }
}

extension CalendarView: JTAppleCalendarViewDelegate {
    
    //MARK: - Custom CalendarCell appears to collectionView
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let calendarCell = cell as! CalendarCell
        calendarCell.dateLabel.text = cellState.text
        //Used for transfering to the right date after clicking on the calendar
        calendarCell.date = cellState.date
        
        //MARK: - Add emojis to each cell
        var currentDayDate = [DayDate]()
        
        //MARK: Add all emojis from a day or just for one tracker
        //If trackerCalendar was performed
        if sender != nil {
            guard let start = cellState.date.startOfTheDay() else { fatalError("start date is invalid") }
            guard let end = cellState.date.endOfTheDay() else { fatalError("end date is invalid") }
            
            let idPredicate = NSPredicate(format: "ANY tracker == %@", sender!.objectID)
            let datePredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as CVarArg, end as CVarArg)
            let predicate = NSCompoundPredicate(type: .and, subpredicates: [idPredicate, datePredicate])
            currentDayDate = coredata.fetchDayData(with: predicate)
        } else {
            currentDayDate = coredata.getFilteredDays(date: cellState.date)
        }
        
        var emojiString = ""
        for log in currentDayDate {
            emojiString += log.emoji ?? ""
        }
        
        calendarCell.emojiLabel.text = emojiString
       
        //MARK: UI for dates not belonged to current month
        if cellState.dateBelongsTo != .thisMonth {
            calendarCell.dateLabel.textColor = UIColor.lightGray
            calendarCell.emojiLabel.alpha = 0.3
        } else {
            calendarCell.dateLabel.textColor = UIColor(red: 0.26, green: 0.47, blue: 0.96, alpha: 1)
            calendarCell.emojiLabel.alpha = 1
        }
        
        //MARK: Add UI for today's cell
        currentDateObj.restoreTimeLine()
        if cellState.date == currentDateObj.now.startOfTheDay() {
            calendarCell.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.00, alpha:1.0).cgColor
            calendarCell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
            calendarCell.dateLabel.textColor = UIColor(red:0.35, green:0.00, blue:0.00, alpha:1.0)
        } else {
            calendarCell.layer.borderColor = UIColor.clear.cgColor
            calendarCell.backgroundColor = UIColor.clear
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateCalendarHeader(dates: visibleDates)
        
    }
    
    func updateCalendarHeader(dates visibleDates : DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else {
            fatalError("date cannot be obtained")
        }
        
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "YYYY"
        yearLabel.text = dateFormatter.string(from: date)
    }
    
}
