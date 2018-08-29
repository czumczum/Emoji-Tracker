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
    
    let dateFormatter = DateFormatter().getFormattedDate()
    
    @IBOutlet var collectionView: JTAppleCalendarView!
    
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

extension CalendarView: JTAppleCalendarViewDelegate {
    
    //MARK: - Custom CalendarCell appears to collectionView
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let calendarCell = cell as! CalendarCell
        calendarCell.dataLabel.text = cellState.text
        
        print(cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let selectedCell = cell as? CalendarCell else {
            fatalError("There was a problem with selecting a cell")
        }
        
        selectedCell.layer.borderColor = UIColor(red:0.98, green:0.45, blue:0.62, alpha:1.0).cgColor
        selectedCell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    }
    
}
