//
//  FAQsDetailTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 08/09/2022.
//

import UIKit

class FAQsDetailTableCell: UITableViewCell {

    override class func description() -> String {
        return "FAQsDetailTableCell"
    }
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
}
