//
//  SingleBookingCancelledPopupViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class SingleBookingCancelledPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)
    }
    @IBAction func continueBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .RefreshEventDetails, object: nil)
        }
    }
}
