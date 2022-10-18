//
//  NotificationTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class NotificationTableCell: UITableViewCell {
    override class func description() -> String {
        return "NotificationTableCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
