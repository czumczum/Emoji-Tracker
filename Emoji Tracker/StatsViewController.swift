//
//  StatsViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/2/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var statsTableView: UITableView!
    @IBOutlet var statsCollection: UITableView?
    
    var emojis = [(String, Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojis = sortEmojis()
    }
    
    //MARK: - Stats Swipping pages dismiss button
    
    @IBAction func dismissStatsButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Statistic's functions
    func sortEmojis() -> [(String, Int)] {
        let allDayDate = coredata.fetchDayData()
        var emojis = [String]()
        var emojiCount: [String: Int] = [:]
        
        for day in allDayDate {
            if let emoji = day.emoji {
                emojis.append(emoji)
            }
        }
        
        emojis.forEach { emojiCount[$0, default: 0] += 1 }
        
        let sortedEmojis = emojiCount.sortedByValue
        
        return sortedEmojis
    }
    
    func getPercentForEmoji(emojiList: [(String, Int)], emojiCount: Int) -> Int {
        let total = emojiList.reduce(0) { (sum, dict) in sum + (dict.1) }
        
        return (emojiCount * 100)/total
    }
    
}

extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if emojis.count >= 10 {
            numberOfRows = 10
        } else {
            numberOfRows = emojis.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        let emoji = "\(emojis[indexPath.row])"
        let percent = getPercentForEmoji(emojiList: emojis, emojiCount: emojis[indexPath.row].1)
        
        cell.textLabel?.text = emoji[2..<3]
        cell.detailTextLabel?.text = "\(percent)%"
        
        return cell
    }
    
    
}


