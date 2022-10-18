//
//  CancellationPolicyTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class CancellationPolicyTableCell: UITableViewCell {

    override class func description() -> String {
        return "CancellationPolicyTableCell"
    }
    @IBOutlet weak var policyTime: UILabel!
    @IBOutlet weak var refund: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
}
