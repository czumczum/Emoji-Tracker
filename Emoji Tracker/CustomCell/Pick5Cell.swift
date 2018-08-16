

import UIKit
import SwipeCellKit

protocol clickDelegate {
    func createNewRecord(emoji: String, tracker: String)
}

class Pick5Cell: SwipeTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    var clickDelegate : clickDelegate?
    
    @IBOutlet var collectionOfButtons: Array<UIButton>?
    

    @IBAction func buttonClicked( sender: UIButton) {
        
        emojiLabel.text = sender.titleLabel?.text
        
        if let emoji = emojiLabel.text, let tracker = titleLabel.text {
        
            clickDelegate?.createNewRecord(emoji: emoji, tracker: tracker)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }

}
