//
//  CalendarCell.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/29/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var labelBg: UIView!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var cellArea: UIView!
    
    var date: Date = Date()
    
}
