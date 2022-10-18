//
//  HomeHeaderCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class HomeHeaderCollectionCell: UICollectionViewCell {
    override class func description() -> String {
        return "HomeHeaderCollectionCell"
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
