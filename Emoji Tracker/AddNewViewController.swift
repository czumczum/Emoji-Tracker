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
        newTrackerName?.delegate = self
        newTrackerEmojis?.delegate = self
        
        //The emoji fields and 'done' button are hide as default
        addNewTrackerButton?.isHidden = true
        newTrackerEmojis.isHidden = true
        newTrackerEmojisLabel.isHidden = true
    
    }
    
    @IBAction func dismissNewItemButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Text fields w/labels
    
    @IBOutlet var newTitleLabel: UILabel!
    @IBOutlet var newEmojisLabel: UILabel!
    
    @IBOutlet var newTrackerName: UITextField!
    
    
    @IBOutlet var newTrackerEmojisLabel: UILabel!
    @IBOutlet var newTrackerEmojis: UITextField!
    @IBAction func newTrackerEmojisChanged(_ sender: UITextField) {
        if newTrackerType == "pick5", let field = sender.text {
            if field.count > 5 {
                sender.deleteBackward()
            }
        }
    }
    
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
        activateAddNewEmojiFields()
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
        
        let emojis = newTrackerEmojis.text!.replacingOccurrences(of: " ", with: "")
        
        let tracker = Tracker(context: context)
        tracker.title = newTrackerName.text!
        tracker.emojis = emojis
        tracker.type = newTrackerType
        
        coredata.trackerArray.append(tracker)
        
        coredata.saveContext()

        self.dismiss(animated: true)
    }
    
    func activateAddNewTrackerButton() {
        if newTrackerName.text != "" && newTrackerType != "" {
            
            if newTrackerType == "input" {
                addNewTrackerButton.isHidden = false
                
            } else if newTrackerEmojis.text != "" {
                addNewTrackerButton.isHidden = false
                
            } else {
                addNewTrackerButton.isHidden = true
            }
        }
    }
    
    func activateAddNewEmojiFields() {
        if newTrackerType == "pick5" {
            newTrackerEmojis.isHidden = false
            newTrackerEmojisLabel.isHidden = false
            newTrackerEmojis.placeholder = "Pick 5"
            
        } else if newTrackerType == "slider" {
            newTrackerEmojis.isHidden = false
            newTrackerEmojisLabel.isHidden = false
            newTrackerEmojis.placeholder = "Pick a few"
        } else {
            newTrackerEmojis.isHidden = true
            newTrackerEmojisLabel.isHidden = true
            
            newTrackerEmojis.text = ""
        }
        
        updatenewTrackerLabels()
    }
    
    ///////////////////////////////////////////
    
}
