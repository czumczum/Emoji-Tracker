//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }


    //MARK: - Main Board
    @IBOutlet weak var daysStackView: UIStackView!
    
    @IBAction func addTrackerScreenPerformButtonClicked(_ sender: UIButton) {
    }
    
    
    //MARK: - Trackers Board
    @IBOutlet weak var trackersTableView: UITableView!
    @IBOutlet weak var addNewTrackerButtonClicked: UIBarButtonItem!
    
    // MARK: - Adding new tracker Swipping pages
    
    @IBAction func pagination(_ sender: UIPageControl) {
    }
    

    

}

