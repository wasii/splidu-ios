//
//  BillDetailDataTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit

class BillDetailDataTableCell: UITableViewCell {

    override class func description() -> String {
        return "BillDetailDataTableCell"
    }
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
