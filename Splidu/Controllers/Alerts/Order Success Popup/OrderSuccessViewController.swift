//
//  OrderSuccessViewController.swift
//  Splidu
//
//  Created by abdWasiq on 07/09/2022.
//

import UIKit

class OrderSuccessViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var msgLabel: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func seeYourOrderstapped(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .CompleteOrder, object: nil)
            Utilities.topMostController().navigationController?.popToRootViewController(animated: true)
        }
    }
}
