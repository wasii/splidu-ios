//
//  IncomingTableViewCell.swift
//  Splidu
//
//  Created by Rafi on 05/09/2022.
//

import UIKit

class IncomingTableViewCell: UITableViewCell {
    override class func description() -> String {
        return "IncomingTableViewCell"
    }
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
