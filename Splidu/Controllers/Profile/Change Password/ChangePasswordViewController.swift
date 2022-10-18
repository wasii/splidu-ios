//
//  ChangePasswordViewController.swift
//  Splidu
//
//  Created by Rafi on 05/09/2022.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var oldPasswordStackView: UIStackView!
    
    var verifyForgotPassword: ForgotPasswordVerificationType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Change Password"
        setupInterface()
    }
    
    fileprivate func setupInterface() {
        if let _ = verifyForgotPassword {
            oldPasswordStackView.isHidden = true
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if newPassTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter new password")
            return
        }
        if confirmPassTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter confirm password")
            return
        }
        if newPassTextField.text! != confirmPassTextField.text! {
            Utilities.showWarningAlert(message: "Confirm password mismatch")
            return
        }
        
        if let verifyForgotPassword = verifyForgotPassword {
            let parameters = [
                "email" : verifyForgotPassword.email,
                "new_password" : self.newPassTextField.text!,
                "type": verifyForgotPassword.otp_type,
                "mobile": verifyForgotPassword.mobile
            ]
            
            ProfileAPIManager.updateNewPassword(parameters: parameters) { cp in
                switch cp.status {
                case "Fail":
                    Utilities.showWarningAlert(message: cp.message ?? "")
                   
                case "Success":
                    Utilities.showSuccessAlert(message: cp.message ?? "") {
                        Coordinator.LoginScreen()
                    }
                    
                default: break
                }
            }
            
            
        } else {
            if oldPassTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                Utilities.showWarningAlert(message: "Please enter old password")
                return
            }
            let parameters = [
                "old_password" : self.oldPassTextField.text!,
                "new_password" : self.newPassTextField.text!,
                "confirm_password" : self.confirmPassTextField.text!
            ]
            
            ProfileAPIManager.ChangePassword(parameters: parameters) { cp in
                switch cp.status {
                case "Fail":
                    Utilities.showWarningAlert(message: cp.message ?? "")
                    break
                case "Success":
                    Utilities.showSuccessAlert(message: cp.message ?? "")
                    break
                default: break
                }
            }
        }
       
    }
}
