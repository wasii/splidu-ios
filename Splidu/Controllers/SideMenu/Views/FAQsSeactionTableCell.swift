//
//  FAQsSeactionTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class FAQsSeactionTableCell: UITableViewCell {

    override class func description() -> String {
        return "FAQsSeactionTableCell"
    }
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var dropDown: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
