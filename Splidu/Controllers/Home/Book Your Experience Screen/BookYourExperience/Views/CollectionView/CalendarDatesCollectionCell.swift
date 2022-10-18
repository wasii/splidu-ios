//
//  CalendarDatesCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit

class CalendarDatesCollectionCell: UICollectionViewCell {

    override class func description() -> String {
        return "CalendarDatesCollectionCell"
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var monthName: UILabel!
    @IBOutlet weak var monthDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
