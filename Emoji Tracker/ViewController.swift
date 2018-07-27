//
//  ViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/25/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var trackerList : [Trackers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add new tracker
        addNewTrackerButton?.isHidden = true
        newTrackerName?.delegate = self
        newTrackerEmojis?.delegate = self
        
        //Trackers list
        trackersTableView?.delegate = self
        trackersTableView?.dataSource = self
        configureTableView()
        
        let firstTracker = Trackers()
        firstTracker.name = "My dog"
        firstTracker.emojis = "😂🙂😍🤓😱"
        trackerList.append(firstTracker)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Navigation controller w/transparent bg
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        trackersTableView?.reloadData()
    }


    //MARK: - Main Board
    @IBOutlet weak var daysStackView: UIStackView!
    
    @IBAction func addTrackerScreenPerformButtonClicked(_ sender: UIButton) {
    }
    
    
    //MARK: - Trackers Board
    @IBOutlet weak var trackersTableView: UITableView!
    @IBOutlet weak var addNewTrackerButtonClicked: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(trackerList.count)
        return trackerList.count
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("dupa")
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! UITableViewCell
        
        let cell = UITableViewCell()
        cell.textLabel?.text = trackerList[indexPath.row].name
        cell.detailTextLabel?.text = trackerList[indexPath.row].emojis
        
        return cell
    }

    
    //ConfigureTableView
    func configureTableView() {
        trackersTableView?.rowHeight = UITableViewAutomaticDimension
        trackersTableView?.estimatedRowHeight = 120.0
    }
    
    //MARK: - Stats Swipping pages
    
    @IBAction func dismissStatsButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Create new tracker Page
    
    var newTrackerType : String = ""
    
    @IBAction func dismissNewItemButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Text fields w/labels
    
    @IBOutlet var newTitleLabel: UILabel!
    @IBOutlet var newEmojisLabel: UILabel!
    @IBOutlet var newTrackerName: UITextField!
    @IBOutlet var newTrackerEmojis: UITextField! //TODO: Add max 5 symbol limit to the newTrackerEmojis
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activateAddNewTrackerButton()
        updatenewTrackerLabels()
        textField.endEditing(true)
        return true
    }
    
    func updatenewTrackerLabels() {
        newTitleLabel.text = newTrackerName.text ?? " "
        newEmojisLabel.text = newTrackerEmojis.text ?? " "
    }
    
    ///////////////////////////////////////////
    
    //MARK: Radio buttons
    
    @IBOutlet var newTrackerStackview: UIStackView!
    @IBAction func newTrackerTypeInputClicked(_ sender: UIButton) {
        newTrackerType = "input"
        activateAddNewTrackerButton()
        makeButtonSelected(with: sender)
    }
    @IBAction func newTrackerTypePick5Clicked(_ sender: UIButton) {
        newTrackerType = "pick5"
        activateAddNewTrackerButton()
        makeButtonSelected(with: sender)
    }
    @IBAction func newTrackerTypeSliderClicked(_ sender: UIButton) {
        newTrackerType = "slider"
        activateAddNewTrackerButton()
        makeButtonSelected(with: sender)
    }
    
    func makeButtonSelected(with sender: UIButton) {
        for case let button as UIButton in self.newTrackerStackview.subviews  {
            if button.isSelected {
                // deselect all buttons
                button.isSelected = false
            }
        }
        // select/unselect the clicked button
        sender.isSelected = !sender.isSelected
    }
    
    ///////////////////////////////////////////
    
    //Add new tracker button
    @IBOutlet var addNewTrackerButton: UIButton!
    @IBAction func addNewTrackerButtonClicked(_ sender: UIButton) {
        
        let tracker = Trackers()
        tracker.name = newTrackerName.text!
        tracker.emojis = newTrackerEmojis.text!
        
        trackerList.append(tracker)
        print(trackerList.count)

        trackersTableView?.reloadData()
        self.dismiss(animated: true) {
            self.trackersTableView?.reloadData()
        }
    }
    
    func activateAddNewTrackerButton() {
        if newTrackerName.text != "" && newTrackerEmojis.text != "" && newTrackerType != "" {
            addNewTrackerButton.isHidden = false
        }
    }
    
    ///////////////////////////////////////////
    
    

}

