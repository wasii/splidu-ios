//
//  HomeCategoryListingTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class HomeCategoryListingTableCell: UITableViewCell {

    override class func description() -> String {
        return "HomeCategoryListingTableCell"
    }
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var cuisineName: UILabel!
    
    @IBOutlet weak var discountView: UIView!
    
    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    
    var oldPriceValue: String = "AED 400"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let attributeString =  NSMutableAttributedString(string: oldPriceValue)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        self.oldPrice.attributedText = attributeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
}
