//
//  AddGuestButtonTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import UIKit

class AddGuestButtonTableCell: UITableViewCell {
    @IBOutlet weak var addGuestView: UIView!
    
    @IBOutlet weak var addGuestBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    override class func description() -> String {
        return "AddGuestButtonTableCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    var didTapOnInviteGuest: (() -> Void) = {}
    
    
    @IBAction func inviteGuestActionBtnTap(_ sender: Any) {
        didTapOnInviteGuest()
    }
}
