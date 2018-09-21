//
//  AboutPageController.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 9/12/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit


class AboutPageController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func fbLink(_ sender: UIButton) {
        
        if let url = NSURL(string: "https://www.facebook.com/Emoji-Tracker-299959120794056/") {
            UIApplication.shared.open(url as URL)
        }
    }
    
    @IBAction func emailLink(_ sender: UIButton) {
        guard let email = sender.titleLabel?.text else { return }
        if let url = NSURL(string: "mailto:\(email)") {
            UIApplication.shared.open(url as URL)
        }
    }
    
    @IBAction func privacyLink(_ sender: UIButton) {
        
        if let url = NSURL(string: "https://app.termly.io/document/privacy-policy/92d9c120-a388-4bf9-a854-c51858aeb66f") {
            UIApplication.shared.open(url as URL)
        }
        
    }
    
}
