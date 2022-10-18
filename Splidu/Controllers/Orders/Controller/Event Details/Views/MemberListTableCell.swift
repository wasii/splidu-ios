//
//  MemberListTableCell.swift
//  Splidu
//
//  Created by NaheedPK on 19/09/2022.
//

import UIKit

class MemberListTableCell: UITableViewCell {
    override class func description() -> String {
        return "MemberListTableCell"
    }
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personGender: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var seperator: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
