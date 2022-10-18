//
//  LoginScreenViewController.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit
import GoogleSignIn


class LoginScreenViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UnderLineImageTextField! {
        didSet {
            emailTextField.addTarget(self, action: #selector(textChanges(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.addTarget(self, action: #selector(textChanges(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    var isUserRemebered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(navigateSignup), name: NSNotification.Name.init(rawValue: "Signup"), object: nil)
        AppDelegate.appDelegateInstance?.isGuestModeEnabled = false
       
//        #if DEBUG
//        emailTextField.text = "saadqadeer64@gmail.com"
//        passwordTextField.text = "admin"
//        #endif
    }
    
    private func isValid() -> Bool {
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            emailErrorLbl.text = "Please enter email*"
            emailErrorLbl.isHidden = false
            self.emailTextField.becomeFirstResponder()
            return false
        }
        if !(emailTextField.text?.isValidEmail() ?? false) {
            emailErrorLbl.text = "Email address is not valid"
            emailErrorLbl.isHidden = false
            self.emailTextField.becomeFirstResponder()
            return false
        }
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            passwordErrorLbl.isHidden = false
            self.passwordTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func rememberBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isUserRemebered = sender.isSelected
       
    }
    @IBAction func loginBtnTapped(_ sender: Any) {
        if isValid() {
            view.endEditing(true)
            let parameters:[String:String] = [
                "email" : emailTextField.text ?? "",
                "password" : passwordTextField.text ?? ""
            ]
            AuthenticationAPIManager.loginAPI(parameters: parameters) { [self] result in
                switch result.status {
                case "Success":
                    isUserRemebered ? (UserDefaults.standard.set(true, forKey: UserDefaults.AppUserDefault.isRemeberLoginUser)) : ((UserDefaults.standard.set(false, forKey: UserDefaults.AppUserDefault.isRemeberLoginUser)))
                    Coordinator.gotoTabBar()
                    break
                case "Fail":
                    Utilities.showSuccessAlert(message: result.message ?? "")
                default: break
                }
            }
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        Coordinator.showSignUpScreen(delegate: self)
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        Coordinator.showForgotPassword(delegate: self)
    }
    
    @IBAction func skipActionBtnTap(_ sender: Any) {
        AppDelegate.appDelegateInstance?.isGuestModeEnabled = true
        Coordinator.gotoTabBar()
    }
    
    @IBAction func googleLoginActionBtnTap(_ sender: Any) {
        GoogleSignInManager.shared.googleSignInDelegate = self
        GoogleSignInManager.shared.signInWithGoogle(presentingController: self)
    }
    
    @IBAction func facebookLoginActionBtnTap(_ sender: Any) {
        FBSignInManager.shared.signInWithFaceBook(selfVC: self) { [weak self] result in
            guard let result = result else {
                Utilities.showWarningAlert(message: "Unable to sign in please try again")
                return
            }
            self?.callSocialMediaFBLoginAPI(fbData: result)
        }
    }
    
    
    @IBAction func appleLoginActionBtnTap(_ sender: Any) {
        AppleSignInManager.shared.handleAppleIdRequest()
        AppleSignInManager.shared.appleSignInDelegate = self
    }
    
    @objc func navigateSignup(){
        Coordinator.showSignUpScreen(delegate: self)
    }
}

// MARK: - TextFieldEditing Chnaged
extension LoginScreenViewController {
    @objc func textChanges(_ textField: UITextField) {
        let text = textField.text!
        if textField == emailTextField && text.count > 0 {
            emailErrorLbl.isHidden = true
        } else if textField == passwordTextField && text.count > 0 {
            passwordErrorLbl.isHidden = true
        }
    }
}

// MARK: - SignInWith Apple Delegate Implemetation
extension LoginScreenViewController: AppleAuthorization {
    func didAuthorizedWithAppleSuccessfully(appleData: AppleSignInData) {
        callSocialMediaAppleLoginApi(appleData: appleData)
    }
    
    func didFailToAuthorizeWithApple(errorString: String) {
        Utilities.showWarningAlert(message: "Unable to sign in please try again")
    }
}

// MARK: - SignInWith Google Delegate Implemetation
extension LoginScreenViewController: GoogleSignIn {
    func didLoginWithGoogle(user: GIDGoogleUser) {
        callSocialMediaGoogleLoginApi(userData: user)
    }
    
    func didFailToLoginWithGoogle(error: Error) {
        Utilities.showWarningAlert(message: error.localizedDescription)
    }
}
    
// MARK: - Webservice Call
extension LoginScreenViewController {
    fileprivate func callSocialMediaAppleLoginApi(appleData: AppleSignInData) {
        let userName = appleData.userName.components(separatedBy: " ")
        let firstName: String = userName.first ?? ""
        let lastName: String = userName.last ?? ""
        let params = AuthenticationAPIManager.SocialMediaLoginApiParams(firstName: firstName, lastName: lastName, email: appleData.email, socialKey: appleData.token)
        authenticateSocialLogin(params: params)
    }
    
    fileprivate func callSocialMediaGoogleLoginApi(userData: GIDGoogleUser) {
        let userName = userData.profile?.name.components(separatedBy: " ")
        let firstName: String = userName?.first ?? ""
        let lastName: String = userName?.last ?? ""
        let params = AuthenticationAPIManager.SocialMediaLoginApiParams(firstName: firstName, lastName: lastName, email: userData.profile!.email, socialKey: userData.userID!)
        authenticateSocialLogin(params: params)
    }
    
    fileprivate func callSocialMediaFBLoginAPI(fbData: FBResponseHandler) {
        let params = AuthenticationAPIManager.SocialMediaLoginApiParams(firstName: fbData.firstName, lastName: fbData.lastName, email: fbData.email, socialKey: fbData.id)
        authenticateSocialLogin(params: params)
    }
    
    fileprivate func authenticateSocialLogin(params: AuthenticationAPIManager.SocialMediaLoginApiParams) {
        AuthenticationAPIManager.socialLoginApi(params: params) { result in
            guard let result = result else {
                Utilities.showWarningAlert(message: "Unable to sign in please try again")
                return
            }
            
            switch result.status {
            case "Success":
                let userLoggedIn: (() -> Void) = {
                    guard let token =  result.token else { return }
                    UserDefaults.standard.set(token, forKey: ud_user_token)
                    SessionManager.setUserData(dictionary: result.dictionary as NSDictionary?)
                    SocialLogger.shared.enableSocialLogin()
                    UserDefaults.standard.set(true, forKey: UserDefaults.AppUserDefault.isRemeberLoginUser)
                    Coordinator.gotoTabBar()
                }
                
                if let mobileNo = result.user?.mobile {
                    if mobileNo.count > 0 {
                        userLoggedIn()
                        return
                    }
                }
                
                Coordinator.shoeMobileOTP(delegate: self, socialID: params.socialKey)
                
            case "Fail":
                Utilities.showSuccessAlert(message: result.message ?? "")
            
            default: break
                
            }
        }
    }
}
