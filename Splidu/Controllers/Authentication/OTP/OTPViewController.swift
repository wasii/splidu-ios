//
//  OTPViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit
import DPOTPView

struct NewUserRegistration {
    var email: String
    var isRegisterNewUser: Bool = true
}

struct ForgotPasswordVerificationType {
    var email: String
    var otp: String
    var verify_type: String
    var otp_type: String
    var mobile: String
}

struct VerifyMobileOTP {
    var social_id: String
    var mobile: String
}

class OTPViewController: BaseViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var optView: DPOTPView!
    @IBOutlet weak var resendOTP: UIButton!
    
    var timer: Timer?
    var seconds = 60
    var newRegisteredUser: NewUserRegistration? = nil
    var verifyForgotPassword: ForgotPasswordVerificationType? = nil
    var verifyMobileOTP: VerifyMobileOTP? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optView.becomeFirstResponder()
        self.runTimer()
        if let _  = verifyForgotPassword {
            type = .backBlack
        } else if let _ = verifyMobileOTP {
            type = .backBlack
        }
    }
    
    @IBAction func changeEmailNumberTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if optView.validate() {
            if optView.text == "1111" {
                callVerifyOTP_API()
                
            } else {
                Utilities.showWarningAlert(message: "Invalid OTP")
            }
        } else {
            Utilities.showWarningAlert(message: "Please enter 4 digit valid OTP")
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.resendOTP.isUserInteractionEnabled = false
        seconds -= 1
        hmsFrom(seconds: seconds) {minutes, second in
            self.timerLabel.text = "\(self.getStringFrom(seconds: minutes)):\(self.getStringFrom(seconds: second)) sec"
            if self.seconds == 0 {
                self.timer?.invalidate()
                self.resendOTP.isUserInteractionEnabled = true
            }
        }
    }
    
    func hmsFrom(seconds: Int, completion: @escaping (_ minutes: Int, _ seconds: Int)->()) {
        completion((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @IBAction func resendOTPTapped(_ sender: Any) {
       callResendOTP_API()
    }
}

// MARK: - Webservice Call
extension OTPViewController {
    fileprivate func callVerifyOTP_API() {
        if let newUser = newRegisteredUser {
            let params = AuthenticationAPIManager.VerifyOTPApiParams(email: newUser.email, otp: optView.text!)
            AuthenticationAPIManager.verifyOTPApi(params: params) { result in
                guard let result = result else {
                    return
                }
                switch result.status {
                case "Success":
                    guard let token =  result.token else { return }
                    UserDefaults.standard.set(token, forKey: ud_user_token)
                    SessionManager.setUserData(dictionary: result.dictionary as NSDictionary?)
                    UserDefaults.standard.set(true, forKey: UserDefaults.AppUserDefault.isRemeberLoginUser)
                    Coordinator.gotoTabBar()
                    
                case "Fail":
                    Utilities.showSuccessAlert(message: result.message ?? "")
                
                default: break
                }
            }
            
        } else if var verifyForgotPassword = verifyForgotPassword {
            verifyForgotPassword.otp = optView.text!
            let params = AuthenticationAPIManager.ForgotPasswordOTPApiParams(email: verifyForgotPassword.email, otp: verifyForgotPassword.otp, verify_type: verifyForgotPassword.verify_type, otp_type: verifyForgotPassword.otp_type, mobile: verifyForgotPassword.mobile)
            AuthenticationAPIManager.verifyForgotPasswordOTPApi(params: params) { result in
                guard let result = result else {
                    return
                }
                switch result.status {
                case "Success":
                    Coordinator.changePassword(delegate: self, verifyForgotPasswordPassword: verifyForgotPassword)
                    
                case "Fail":
                    Utilities.showSuccessAlert(message: result.message ?? "")
                
                default: break
                }
            }
            
        } else if let verifyMobileOTP = verifyMobileOTP {
            let params = AuthenticationAPIManager.VerifyMobileOTPApiParams(otp: optView.text!, mobile: verifyMobileOTP.mobile, socialID: verifyMobileOTP.social_id)
            AuthenticationAPIManager.verifyMobileOTPApi(params: params) { result in
                guard let result = result else {
                    return
                }
                guard let token =  result.token else { return }
                UserDefaults.standard.set(token, forKey: ud_user_token)
                SessionManager.setUserData(dictionary: result.dictionary as NSDictionary?)
                SocialLogger.shared.enableSocialLogin()
                UserDefaults.standard.set(true, forKey: UserDefaults.AppUserDefault.isRemeberLoginUser)
                Coordinator.gotoTabBar()
            }
        }
    }
    
    fileprivate func callResendOTP_API() {
        if let newUser = newRegisteredUser {
            let params = AuthenticationAPIManager.ResendOTPApiParams(email: newUser.email)
            AuthenticationAPIManager.resendOTPApi(params: params) { [self] result in
                guard let result = result else {
                    return
                }
                switch result.status {
                case "Success":
                    Utilities.showSuccessAlert(message: result.message ?? "") { [self] in
                        optView.text = ""
                        self.seconds = 60
                        self.runTimer()
                    }
                    
                case "Fail":
                    Utilities.showSuccessAlert(message: result.message ?? "")
                
                default: break
                }
            }
        } else if let verifyForgotPassword = verifyForgotPassword {
            let params = AuthenticationAPIManager.ForgotPasswordResendOTPApiParams(email: verifyForgotPassword.email, otp_type: verifyForgotPassword.otp_type, type: verifyForgotPassword.verify_type)
            AuthenticationAPIManager.forgotPasswordResendOTPApi(params: params) { result in
                guard let result = result else {
                    return
                }
                switch result.status {
                case "Success":
                    Utilities.showSuccessAlert(message: result.message ?? "") { [self] in
                        optView.text = ""
                        self.seconds = 60
                        self.runTimer()
                    }
                    
                case "Fail":
                    Utilities.showSuccessAlert(message: result.message ?? "")
                
                default: break
                }
            }
        }
    }
}
