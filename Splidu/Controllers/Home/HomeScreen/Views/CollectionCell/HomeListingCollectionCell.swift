//
//  HomeListingCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class HomeListingCollectionCell: UICollectionViewCell {
    override class func description() -> String {
        return "HomeListingCollectionCell"
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
