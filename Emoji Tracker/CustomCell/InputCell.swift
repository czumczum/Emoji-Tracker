

import UIKit
import SwipeCellKit

class InputCell: SwipeTableViewCell, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var emojiInput: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tracker = coredata.fetchTrackerById(with: trackerId)
        
        if let emojiStr = emojiInput.text {
            let emoji = emojiStr[emojiStr.startIndex]
            clickDelegate?.createNewRecord(emoji: "\(emoji)", tracker: tracker)
            emojiLabel.text = String(emoji)
        }
        emojiInput.endEditing(true)
        return true
    }
    
     var clickDelegate : clickDelegate?
    
    var trackerId : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emojiInput?.delegate = self
    }

}
