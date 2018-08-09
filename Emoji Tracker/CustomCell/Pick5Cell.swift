

import UIKit

protocol clickDelegate {
    func createNewRecord(emoji: String, tracker: String)
}

class Pick5Cell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    var delegate : clickDelegate?
    
    @IBOutlet var collectionOfButtons: Array<UIButton>?
    

    @IBAction func buttonClicked( sender: UIButton) {
        
        emojiLabel.text = sender.titleLabel?.text
        
        if let emoji = emojiLabel.text, let tracker = titleLabel.text {
        
            delegate?.createNewRecord(emoji: emoji, tracker: tracker)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }

}
