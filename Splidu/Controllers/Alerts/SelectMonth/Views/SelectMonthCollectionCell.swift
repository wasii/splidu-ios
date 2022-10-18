//
//  SelectMonthCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit

class SelectMonthCollectionCell: UICollectionViewCell {
    override class func description() -> String {
        return "SelectMonthCollectionCell"
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
