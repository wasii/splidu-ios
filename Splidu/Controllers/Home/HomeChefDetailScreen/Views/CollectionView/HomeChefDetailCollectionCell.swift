//
//  HomeChefDetailCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 31/08/2022.
//

import UIKit

class HomeChefDetailCollectionCell: UICollectionViewCell {

    override class func description() -> String {
        return "HomeChefDetailCollectionCell"
    }
    @IBOutlet weak var gradientBottom: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var optionTitle: UILabel!
    @IBOutlet weak var optionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
