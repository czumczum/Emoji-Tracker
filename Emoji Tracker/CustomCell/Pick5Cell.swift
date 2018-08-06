

import UIKit

protocol clickDelegate {
    func createNewDayDate(emoji: String, tracker: String)
}

class Pick5Cell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    var delegate : clickDelegate?
    
    @IBOutlet var collectionOfButtons: Array<UIButton>?
    

    @IBAction func buttonClicked( sender: UIButton) {
        if let emoji = emojiLabel.text, let tracker = titleLabel.text {
            // ADD protocol delegate, change to variables
            
            emojiLabel.text = sender.titleLabel?.text
            delegate?.createNewDayDate(emoji: emoji, tracker: tracker)
            print(mainController)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }

}
