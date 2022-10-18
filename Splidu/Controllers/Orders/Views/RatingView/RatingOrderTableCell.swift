//
//  RatingOrderTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit
import Cosmos

class RatingOrderTableCell: UITableViewCell {

    override class func description() -> String {
        return "RatingOrderTableCell"
    }
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var rateTitle: UILabel!
    @IBOutlet weak var totalRate: UILabel!
    @IBOutlet weak var rateStar: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
//        rateStar.
        // Configure the view for the selected state
    }
    
}
