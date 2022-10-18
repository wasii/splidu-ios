//
//  SearchTableViewCell.swift
//  Splidu
//
//  Created by Muhammad Waqas Rafeeq on 05/09/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgBadge: UIImageView!
    @IBOutlet weak var iconHeart: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
