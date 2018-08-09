

import UIKit

class SliderCell: UITableViewCell {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var slider: UISlider!
    
    var delegate : clickDelegate?
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        if let emojis = sender.accessibilityIdentifier, let tracker = titleLabel.text {
            let emoji = String(Array(emojis)[Int(sender.value)])
            emojiLabel.text = emoji
            delegate?.createNewRecord(emoji: emoji, tracker: tracker)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    
    }

}
