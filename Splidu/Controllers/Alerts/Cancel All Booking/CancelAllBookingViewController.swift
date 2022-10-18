//
//  CancelAllBookingViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class CancelAllBookingViewController: UIViewController {

    var deduction = ""
    @IBOutlet weak var deductionLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deductionLbl.text = "You will only get \(deduction)% of the total paid amount into your splidu wallet in line with the cancellation policy."
        view.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func proceedBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .ShowAllBookingCancelSuccessPopup, object: nil)
        }
    }
}
