//
//  AddFundViewController.swift
//  Splidu
//
//  Created by Rafi on 02/09/2022.
//

import UIKit
import Stripe

class AddFundViewController: BaseViewController {

    @IBOutlet weak var fundTxtField: UnderLineImageTextField!
    var secretkey = ""
    var transID = ""
    var paymentSheet: PaymentSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Add Fund"
    }

    @IBAction func addFundActionBtnTap(_ sender: Any) {
        if fundTxtField.text!.isEmpty {
            Utilities.showWarningAlert(message: "Please enter fund amount")
        } else {
            getStripeRefKeyAPI()
        }
    }
}

// MARK: - Stripe Integration
extension AddFundViewController {
    fileprivate func launchStripePaymentSheet() {
        var paymentSheetConfiguration = PaymentSheet.Configuration()
        paymentSheetConfiguration.merchantDisplayName = "Splidu"
        paymentSheetConfiguration.style = .alwaysLight
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: secretkey, configuration: paymentSheetConfiguration)
        self.paymentSheet?.present(from: self) { paymentResult in
           
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                print("payment completed")
                self.addFundsToWalletApi()
                
            case .canceled:
                print("User Cancelled")
                Utilities.showWarningAlert(message: "User cancelled the payment flow")
                
            case .failed(_):
                print("Failed")
                Utilities.showWarningAlert(message: "Payment Failed")
            }
        }
    }
}

// MARK: - Webservice Call
extension AddFundViewController {
    fileprivate func addFundsToWalletApi() {
        let params = ProfileAPIManager.AddWalletApiParams(amount: fundTxtField.text!)
        ProfileAPIManager.addMyWallet(params: params) { result in
            guard let result = result else { return }
            if result.status == "Success" {
                Utilities.showSuccessAlert(message: "Fund added successfully") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                Utilities.showWarningAlert(message: result.status ?? "")
            }
        }
    }
    
    fileprivate func getStripeRefKeyAPI() {
        let param = HomeAPIManager.StripeAPIParams(amount: fundTxtField.text!)
        HomeAPIManager.getStripeRefrenceAPI(params: param) { [self] result in
            guard let result = result else {
                return
            }
            self.transID = result.transactionID
            self.secretkey = result.paymentRefrence
            launchStripePaymentSheet()
        }
    }
}
