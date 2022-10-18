//
//  FundTransferViewController.swift
//  Splidu
//
//  Created by Rafi on 03/09/2022.
//

import UIKit

class FundTransferViewController: BaseViewController {

    @IBOutlet weak var walletIDTxtField: UITextField!
    @IBOutlet weak var walletAmountTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Fund Transfer"
    }
    
    
    @IBAction func submitActionBtnTap(_ sender: Any) {
        if walletIDTxtField.text!.isEmpty {
            Utilities.showWarningAlert(message: "Please enter wallet ID")
            return
        }
        if walletAmountTxtField.text!.isEmpty {
            Utilities.showWarningAlert(message: "Please enter wallet amount")
            return
        }
        callFundsTransferAPI()
    }
}

//MARK: - Funds Transfer API Call
extension FundTransferViewController {
    fileprivate func callFundsTransferAPI() {
        let params = ProfileAPIManager.WalletTransferApiParams(amount: walletAmountTxtField.text!, walletID: walletIDTxtField.text!)
        ProfileAPIManager.walletTransfer(params: params) { [self] result in
            guard let result = result else {
                return
            }
            if result.status == "Success" {
                Utilities.showSuccessAlert(message: result.message ?? "") { [self] in                    navigationController?.popViewController(animated: true)
                }
            } else {
                Utilities.showWarningAlert(message: result.message ?? "")
            }
        }
    }
}
