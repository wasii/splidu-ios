//
//  OutgoingTableViewCell.swift
//  Splidu
//
//  Created by Rafi on 05/09/2022.
//

import UIKit

class OutgoingTableViewCell: UITableViewCell {

    override class func description() -> String {
        return "OutgoingTableViewCell"
    }
    
    @IBOutlet weak var bubbleBackgroundView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        messageLabel.preferredMaxLayoutWidth = 200
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


