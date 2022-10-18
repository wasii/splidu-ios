//
//  FavouriteTabSelectionTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit
import PagingKit

class FavouriteTabSelectionTableCell: PagingMenuViewCell {

    override class func description() -> String {
        return "FavouriteTabSelectionTableCell"
    }
    
    @IBOutlet weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
