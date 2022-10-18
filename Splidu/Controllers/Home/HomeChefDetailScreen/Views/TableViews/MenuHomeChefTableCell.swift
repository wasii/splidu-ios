//
//  MenuHomeChefTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class MenuHomeChefTableCell: UITableViewCell {

    override class func description() -> String {
        return "MenuHomeChefTableCell"
    }
    
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
}
