//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var trackers : [Trackers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        addNewTrackerButton?.isHidden = true
    }


    //MARK: - Main Board
    @IBOutlet weak var daysStackView: UIStackView!
    
    @IBAction func addTrackerScreenPerformButtonClicked(_ sender: UIButton) {
    }
    
    
    //MARK: - Trackers Board
    @IBOutlet weak var trackersTableView: UITableView!
    @IBOutlet weak var addNewTrackerButtonClicked: UIBarButtonItem!
    
    //MARK: - Stats Swipping pages
    
    @IBAction func dismissStatsButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Create new tracker
    

    @IBAction func dismissNewItemButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addNewTrackerButtonClicked(_ sender: UIButton) {
    }
    
    @IBOutlet var addNewTrackerButton: UIButton!
    @IBOutlet var newTitleLabel: UILabel!
    @IBOutlet var newEmojisLabel: UILabel!
    
    @IBOutlet var newTrackerName: UITextField!
    @IBAction func newTrackerTypeInputClicked(_ sender: UIButton) {
    }
    @IBAction func newTrackerTypePick5Clicked(_ sender: UIButton) {
    }
    @IBAction func newTrackerTypeSliderClicked(_ sender: UIButton) {
    }
    @IBOutlet var newTrackerEmojis: UITextField!
    
    
    
    

}

