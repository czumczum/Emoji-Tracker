//
//  TouchGestureRecognizer.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 8/21/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import AudioToolbox

final class ForceTouchGestureRecognizer: UIGestureRecognizer {
    
    private let threshold: CGFloat = 0.75
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = UIGestureRecognizer.State.cancelled
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = UIGestureRecognizer.State.cancelled
    }
    
    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else { return }
        
        if touch.force / touch.maximumPossibleForce >= threshold {
            state = UIGestureRecognizer.State.recognized
        }
    }
    
}
