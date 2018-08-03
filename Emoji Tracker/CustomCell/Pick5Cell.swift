

import UIKit

class Pick5Cell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    var pickedButton : Int = 0
  
    @IBAction func button1(_ sender: UIButton) {
        pickedButton = 1
    }
    @IBAction func button2(_ sender: UIButton) {
        pickedButton = 2
    }
    @IBAction func button3(_ sender: UIButton) {
        pickedButton = 3
    }
    @IBAction func button4(_ sender: UIButton) {
        pickedButton = 4
    }
    @IBAction func button5(_ sender: UIButton) {
        pickedButton = 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }

}
