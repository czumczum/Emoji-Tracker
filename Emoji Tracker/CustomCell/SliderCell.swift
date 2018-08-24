

import UIKit
import SwipeCellKit

class SliderCell: SwipeTableViewCell {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var slider: UISlider!
    
    var clickDelegate : clickDelegate?
    
    var trackerId : String = ""
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        let tracker = coredata.fetchTrackerById(with: trackerId)
        
        if let emojis = sender.accessibilityIdentifier {
            let emoji = String(Array(emojis)[Int(sender.value)])
            emojiLabel.text = emoji
            clickDelegate?.createNewRecord(emoji: emoji, tracker: tracker)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    
    }

}
