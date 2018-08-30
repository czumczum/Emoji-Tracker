

import UIKit
import SwipeCellKit

protocol clickDelegate {
    func createNewRecord(emoji: String, tracker: Tracker)
}

class Pick5Cell: SwipeTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var bottomView: UIView!
    
    var clickDelegate : clickDelegate?
    
    var trackerId : String = ""
    
    @IBOutlet var collectionOfButtons: Array<UIButton>?
    

    @IBAction func buttonClicked( sender: UIButton) {
        
        bottomView.isHidden = true
        
        emojiLabel.text = sender.titleLabel?.text
        let tracker = coredata.fetchTrackerById(with: trackerId)
        
        if let emoji = emojiLabel.text {
        
            clickDelegate?.createNewRecord(emoji: emoji, tracker: tracker)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }

}
