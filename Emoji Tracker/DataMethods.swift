//
//  DataMethods.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/2/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import Foundation

class DataMethods {
    
    func getCurrentDate() -> DateComponents {
        let date = Date()
        let calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return components
    }
}
