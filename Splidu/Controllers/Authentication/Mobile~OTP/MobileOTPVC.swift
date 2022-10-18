//
//  MobileOTPVC.swift
//  Splidu
//
//  Created by Muneeb on 28/09/2022.
//

import UIKit

class MobileOTPVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var socialID: String = ""
    @IBOutlet weak var mobileNoTxtField: UITextField!
    @IBOutlet weak var dialCodeTxtField: UITextField!
}

// MARK: - Actions
extension MobileOTPVC {
    @IBAction func getOTPActionBtnTap(_ sender: Any) {
        if mobileNoTxtField.text!.isEmpty {
            Utilities.showWarningAlert(message: "Please enter mobile no")
        } else {
            sendOTPToMobileNo()
        }
    }
}

// MARK: - Webservice Call
extension MobileOTPVC {
    fileprivate func sendOTPToMobileNo() {
        let params = AuthenticationAPIManager.MobileOTPApiParams(social_id: socialID, mobile: mobileNoTxtField.text!)
        AuthenticationAPIManager.sendMobileOTPApi(params: params) { result in
            guard let result = result else {
                return
            }
            if result.status == "Success" {
                let verifyMobileOTP = VerifyMobileOTP(social_id: self.socialID, mobile: "\(self.dialCodeTxtField.text!)\(self.mobileNoTxtField.text!)")
                Coordinator.showOTPScreen(delegate: self, verifyMobileOTP: verifyMobileOTP)
            }
        }
    }
}

