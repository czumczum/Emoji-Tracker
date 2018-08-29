//
//  CalendarView.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/29/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarView: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    let dateFormatter = DateFormatter().getFormattedDate()
    
    @IBOutlet var collectionView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.calendarDelegate = self
        collectionView.calendarDataSource = self
        
        collectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
    }

    func sharedFunctionToConfigureCell(cell: CalendarCell, cellState: CellState, date: Date) {
        cell.dataLabel.text = cellState.text

        print(cellState)
//        if collectionView.isDateInToday(date) {
//            cell.backgroundColor = UIColor.red
//        } else {
//            cell.backgroundColor = UIColor.white
//        }
    }

    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       
        let calendarCell = cell as! CalendarCell
        
        calendarCell.dataLabel.text = cellState.text
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "MM dd yyyy"
        dateFormatter.locale = Calendar.current.locale
        
        guard let startDate = dateFormatter.date(from: "01 01 2018") else {
            fatalError("Start date coudn't be retreived")
        }
        guard let endDate = dateFormatter.date(from: "12 31 2018") else {
            fatalError("End date coudn't be retreived")
        }
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }

}
