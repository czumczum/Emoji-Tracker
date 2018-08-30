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
    
    @IBOutlet var collectionView: JTAppleCalendarView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Delegates and Custom cells added to VC
        collectionView.calendarDelegate = self
        collectionView.calendarDataSource = self
        
        collectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
        
        setUpCalendarView()

    }
    
    func setUpCalendarView() {
        collectionView.minimumLineSpacing = 1
        collectionView.minimumInteritemSpacing = 1
    }

}

extension CalendarView: JTAppleCalendarViewDataSource {
    
    //MARK: - Calendar configuration
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        calendar.isHidden = true
        
        let myStartDate = dateFormatter.string(from: currentDateObj.oneYearBack())
        let myEndDate = dateFormatter.string(from: currentDateObj.oneYearForward())
        
        guard let startDate = dateFormatter.date(from: myStartDate) else {
            fatalError("Start date coudn't be retreived")
        }
        guard let endDate = dateFormatter.date(from: myEndDate) else {
            fatalError("End date coudn't be retreived")
        }
        
        UIView.animate(withDuration: 2, animations: {
            calendar.scrollToDate(currentDateObj.now)
        }) { (true) in
            calendar.isHidden = false
        }
        
        //MARK: Update month label after first appear
        calendar.visibleDates { (visibleDates) in
            self.updateCalendarHeader(dates: visibleDates)
        }
        
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
        print(cellState.date, currentDateObj.now)
        if cellState.date == currentDateObj.now {
            calendarCell.layer.borderColor = UIColor(red:0.98, green:0.45, blue:0.62, alpha:1.0).cgColor
            calendarCell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
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
