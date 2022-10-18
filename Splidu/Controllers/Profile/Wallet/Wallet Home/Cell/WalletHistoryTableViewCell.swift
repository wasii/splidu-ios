//
//  WalletHistoryTableViewCell.swift
//  Splidu
//
//  Created by Rafi on 02/09/2022.
//

import UIKit

class WalletHistoryTableViewCell: UITableViewCell {

    static let cellIdentifier = "cellIdentifier"
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var walletTitle: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
