//
//  AddGuestDetailTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import UIKit

class AddGuestDetailTableCell: UITableViewCell {

    override class func description() -> String {
        return "AddGuestDetailTableCell"
    }
    @IBOutlet weak var addEditBackView: UIView!
    
    @IBAction func iWillJoinBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBOutlet weak var willJoinBtn: UIButton!
    @IBOutlet weak var willJoinLabel: UILabel!
    @IBOutlet weak var addEditLabel: UIButton!
    @IBOutlet weak var personOneLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UnderLineImageTextField!
    @IBOutlet weak var ageTextField: UnderLineImageTextField!
    
    
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleGradient: UIImageView!
    @IBOutlet weak var femaleBtn: UIButton!
    
    
    @IBOutlet weak var maleView: UIView!
    
    @IBOutlet weak var maleGradient: UIImageView!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var discloseView: UIView!
    @IBOutlet weak var dicloseGradient: UIImageView!
    @IBOutlet weak var discloseBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
}


struct GenderOptions {
    var isMaleSelected: Bool
    var isFemaleSelected: Bool
    var isNotToDisclose: Bool
}
