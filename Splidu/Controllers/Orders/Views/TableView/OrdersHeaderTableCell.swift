//
//  OrdersHeaderTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit
import PagingKit

class OrdersHeaderTableCell: PagingMenuViewCell {

    override class func description() -> String {
        return "OrdersHeaderTableCell"
    }
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
