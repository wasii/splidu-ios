//
//  AppIntroCollectionCell.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit

class AppIntroCollectionCell: UICollectionViewCell {

    override class func description() -> String {
        return "AppIntroCollectionCell"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var introText: UILabel!
    @IBOutlet weak var textWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextActionBtn: UIButton!
    @IBOutlet weak var actionView: UIView!
  
    var didTapOnNextActionBtn: (() -> Void) = {}
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isShowNextActionBtn: Bool = false {
        didSet {
            actionView.isHidden = !isShowNextActionBtn
        }
    }
}

// MARK: - Actions
extension AppIntroCollectionCell {
    @IBAction func nextActionBtnTap(_ sender: Any) {
        didTapOnNextActionBtn()
    }
}
