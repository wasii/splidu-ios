//
//  AddGuestConfirmationTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import UIKit

class AddGuestConfirmationTableCell: UITableViewCell {

    override class func description() -> String {
        return "AddGuestConfirmationTableCell"
    }
    @IBOutlet weak var confirmBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
