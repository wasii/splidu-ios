//
//  NearByChefCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class NearByChefCollectionCell: UICollectionViewCell {

    override class func description() -> String {
        return "NearByChefCollectionCell"
    }
    
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefCuisine: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.50, y: 1.50)
            self.chefImage.borderWidth = 1.3
        }
    }
    func transformToStandard() {
        UIView.animate(withDuration: 0.1) {
            self.chefImage.borderWidth = 1
            self.transform = CGAffineTransform.identity
        }
    }
}
