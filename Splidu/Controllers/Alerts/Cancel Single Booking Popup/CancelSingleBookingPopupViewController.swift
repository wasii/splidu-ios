//
//  CancelSingleBookingPopupViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class CancelSingleBookingPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)
    }
    @IBAction func proceedBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .ShowSingleBookingCancelSuccessPopup, object: nil)
        }
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
