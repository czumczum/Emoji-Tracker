//
//  NewTrackerViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewViewController: UIViewController, UITextFieldDelegate {
        //Create new tracker Page
    
    let realm = try! Realm()
    let realmMethods = RealmMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add new tracker
        addNewTrackerButton?.isHidden = true
        newTrackerName?.delegate = self
        newTrackerEmojis?.delegate = self
    
    }
    
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
        
        let tracker = Tracker()
        tracker.name = newTrackerName.text!
        tracker.emojis = newTrackerEmojis.text!
        
        realmMethods.saveToRealm(with: tracker)
        self.dismiss(animated: true)
    }
    
    func activateAddNewTrackerButton() {
        if newTrackerName.text != "" && newTrackerEmojis.text != "" && newTrackerType != "" {
            addNewTrackerButton.isHidden = false
        }
    }
    
    ///////////////////////////////////////////
    
}
