//
//  BookingConfirmAlertViewController.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import UIKit

protocol NavigateToInviteGuest {
    func navigateToInviteGuest()
}
class BookingConfirmAlertViewController: UIViewController {
    @IBOutlet weak var orderLabel: UILabel!
    var orderNumber = ""
    var navDelegate: NavigateToInviteGuest?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderLabel.text = "#\(orderNumber)"
    }
    @IBAction func inviteGuestTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.navDelegate?.navigateToInviteGuest()
        }
    }
}
