//
//  OfferViewController.swift
//  Splidu
//
//  Created by Wahyd Pvt Ltd on 06/09/2022.
//

import UIKit

class OfferViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Offer"
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
}
