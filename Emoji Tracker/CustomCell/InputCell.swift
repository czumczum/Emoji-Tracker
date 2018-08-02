

import UIKit

class InputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var emojiInput: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emojiInput.endEditing(true)
        return true
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emojiInput?.delegate = self
    }

}
