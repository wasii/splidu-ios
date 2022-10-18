//
//  PeoplesCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class PeoplesCollectionCell: UICollectionViewCell {

    override class func description() -> String {
        return "PeoplesCollectionCell"
    }
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
