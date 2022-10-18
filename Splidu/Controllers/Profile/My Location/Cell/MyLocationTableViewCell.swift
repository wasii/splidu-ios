//
//  MyLocationTableViewCell.swift
//  Splidu
//
//  Created by Rafi on 03/09/2022.
//

import UIKit

class MyLocationTableViewCell: UITableViewCell {
    static var identifier = "MyLocationTableCell"
    
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var selectedAddressBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
