//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var trackerList : [Trackers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }


    //MARK: - Main Board
    @IBOutlet weak var daysStackView: UIStackView!
    
    @IBAction func addTrackerScreenPerformButtonClicked(_ sender: UIButton) {
    }
    
    //MARK: - Stats Swipping pages
    
    @IBAction func dismissStatsButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

