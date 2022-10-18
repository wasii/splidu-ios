//
//  HomeCategoryCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class HomeCategoryCollectionCell: UICollectionViewCell {
    override class func description() -> String {
        return "HomeCategoryCollectionCell"
    }
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
