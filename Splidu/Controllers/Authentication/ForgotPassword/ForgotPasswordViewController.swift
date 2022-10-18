//
//  ForgotPasswordViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    enum VerificationType: String {
        case mobile
        case email
    }
    
    @IBOutlet weak var mobileNoTxtField: UITextField! {
        didSet {
            mobileNoTxtField.delegate = self
        }
    }
    
    @IBOutlet weak var emailAddressTxtField: UITextField! {
        didSet {
            emailAddressTxtField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
    }
    
    @IBAction func getOTPTapped(_ sender: Any) {
        if mobileNoTxtField.text!.isEmpty && emailAddressTxtField.text!.isEmpty {
            Utilities.showWarningAlert(message: "Please enter email or mobile no")
            return
        } else {
            callForgotPasswordAPI()
        }
    }
    
    var verificationType: VerificationType = .mobile
}

// MARK: - TextField Delegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mobileNoTxtField {
            verificationType = .mobile
            emailAddressTxtField.text = ""
            
        } else {
            verificationType = .email
            mobileNoTxtField.text = ""
        }
    }
}

// MARK: - Webservice Call
extension ForgotPasswordViewController {
    fileprivate func callForgotPasswordAPI() {
        let params = AuthenticationAPIManager.ForgotPasswordApiParams(email: verificationType == .email ? (emailAddressTxtField.text!) : (""), mobile: verificationType == .mobile ? (mobileNoTxtField.text!) : (""), type: verificationType.rawValue)
        AuthenticationAPIManager.forgotPasswordApi(params: params) { [self] result in
            guard let result = result else { return  }
            if result.status == "Success" {
                Utilities.showSuccessAlert(message: result.message ?? "") {
                    let verifyForgotPassword = ForgotPasswordVerificationType(email: self.verificationType == .email ? (self.emailAddressTxtField.text!) : (""), otp: "", verify_type: "forgot-password", otp_type: self.verificationType.rawValue, mobile: self.verificationType == .mobile ? (self.mobileNoTxtField.text!) : (""))
                    Coordinator.showOTPScreen(delegate: self, verifyForgotPassword: verifyForgotPassword)
                }
            } else {
                Utilities.showWarningAlert(message: result.message ?? "Server Error")
            }
        }
    }
}
