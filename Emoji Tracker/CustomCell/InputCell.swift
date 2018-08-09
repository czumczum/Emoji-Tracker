

import UIKit

class InputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var emojiInput: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let emojiStr = emojiInput.text {
            let emoji = emojiStr[emojiStr.startIndex]
            delegate?.createNewRecord(emoji: "\(emoji)", tracker: titleLabel.text!)
            emojiLabel.text = String(emoji)
        }
        emojiInput.endEditing(true)
        return true
    }
    
     var delegate : clickDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emojiInput?.delegate = self
    }

}
