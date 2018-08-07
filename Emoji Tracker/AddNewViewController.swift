//
//  NewTrackerViewController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/27/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class AddNewViewController: UIViewController, UITextFieldDelegate {
        //Create new tracker Page
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coredata.loadTrackers()
        
        //Add new tracker
        addNewTrackerButton?.isHidden = true
        newTrackerName?.delegate = self
        newTrackerEmojis?.delegate = self
    
    }
    
    @IBAction func dismissNewItemButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Text fields w/labels
    
    @IBOutlet var newTitleLabel: UILabel!
    @IBOutlet var newEmojisLabel: UILabel!
    @IBOutlet var newTrackerName: UITextField!
    @IBOutlet var newTrackerEmojis: UITextField! //TODO: Add max 5 symbol limit to the newTrackerEmojis
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: 100, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: 100, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditingTextFields()
        return true
    }
    
    func updatenewTrackerLabels() {
        newTitleLabel.text = newTrackerName.text ?? " "
        newEmojisLabel.text = newTrackerEmojis.text ?? " "
    }
    
    // Move the text field to fit upon the keyboard
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        if textField.accessibilityIdentifier == "movable" {
            let moveDuration = 0.3
            let movement: CGFloat = CGFloat(up ? -moveDistance : moveDistance)
            
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(moveDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        }
    }
    
    func endEditingTextFields() {
        updatenewTrackerLabels()
        activateAddNewTrackerButton()
        newTrackerName.endEditing(true)
        newTrackerEmojis.endEditing(true)
    }
    
    
    ///////////////////////////////////////////
    
    //MARK: Radio buttons
    
    var newTrackerType : String = ""
    @IBOutlet var newTrackerStackview: UIStackView!
    @IBAction func newTrackerTypeInputClicked(_ sender: UIButton) {
        newTrackerType = "input"
        makeButtonSelected(with: sender)
        endEditingTextFields()
    }
    @IBAction func newTrackerTypePick5Clicked(_ sender: UIButton) {
        newTrackerType = "pick5"
        makeButtonSelected(with: sender)
        endEditingTextFields()
    }
    @IBAction func newTrackerTypeSliderClicked(_ sender: UIButton) {
        newTrackerType = "slider"
        makeButtonSelected(with: sender)
        endEditingTextFields()
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
        
        let tracker = Tracker(context: context)
        tracker.title = newTrackerName.text!
        tracker.emojis = newTrackerEmojis.text!
        tracker.type = newTrackerType
        
        coredata.trackerArray.append(tracker)
        
        coredata.saveContext()

        self.dismiss(animated: true)
    }
    
    func activateAddNewTrackerButton() {
        if newTrackerName.text != "" && newTrackerEmojis.text != "" && newTrackerType != "" {
            addNewTrackerButton.isHidden = false
        }
    }
    
    ///////////////////////////////////////////
    
}
