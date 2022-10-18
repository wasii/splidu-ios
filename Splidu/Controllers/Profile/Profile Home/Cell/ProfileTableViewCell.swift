//
//  ProfileTableViewCell.swift
//  Splidu
//
//  Created by Rafi on 02/09/2022.
//

import UIKit


class ProfileTableViewCell: UITableViewCell {

    static let identifier = "cellIdentifier"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
