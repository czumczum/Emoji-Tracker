

import UIKit

class TrackDetailCell: UITableViewCell {
    
    //MARK: - LabelCell
    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var emojiLabel: UILabel!
    
    //MARK: - SliderCell
    @IBOutlet var slider: UISlider!
    @IBOutlet var trackerNameLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    //MARK: - Pick5Cell
    
    @IBOutlet var emojiLabel2: UILabel!
    @IBOutlet var trackerNameLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }

}
