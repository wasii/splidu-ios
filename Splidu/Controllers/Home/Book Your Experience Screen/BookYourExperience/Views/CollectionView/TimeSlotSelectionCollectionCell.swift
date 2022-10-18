//
//  TimeSlotSelectionCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit

class TimeSlotSelectionCollectionCell: UICollectionViewCell {

    override class func description() -> String {
        return "TimeSlotSelectionCollectionCell"
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
