//
//  SeatOptionSelectionTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit

class SeatOptionSelectionTableCell: UITableViewCell {

    override class func description() -> String {
        return "SeatOptionSelectionTableCell"
    }
    @IBOutlet weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
