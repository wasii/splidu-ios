//
//  AllBookingCancelledSuccessPopupViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class AllBookingCancelledSuccessPopupViewController: UIViewController {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var refundLbl: UILabel!
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)

    }
    @IBAction func letsExploreTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .ExploreAllBookingCancelled, object: nil)
        }
    }
}
