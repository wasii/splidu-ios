//
//  SignupViewController.swift
//  Splidu
//
//  Created by abdWasiq on 27/08/2022.
//

import UIKit

class SignupViewController: BaseViewController {
let text = "I accept the Terms & conditions and Privacy Policy"
    
    @IBOutlet weak var firstNameTextField: UnderLineImageTextField!
    @IBOutlet weak var firstNameError: UILabel!
    
    @IBOutlet weak var lastNameTextField: UnderLineImageTextField!
    @IBOutlet weak var lastNameError: UILabel!
    
    
    @IBOutlet weak var preferredNameTextField: UnderLineImageTextField!
    @IBOutlet weak var preferrenNameError: UILabel!
    
    
    @IBOutlet weak var emailAddressTextField: UnderLineImageTextField!
    @IBOutlet weak var emailAddressError: UILabel!
    
    @IBOutlet weak var tcLabel: UILabel!
    @IBOutlet weak var countryCode: UnderLineImageTextField!
    @IBOutlet weak var mobileNumber: UnderLineImageTextField!
    @IBOutlet weak var mobileNumberError: UILabel!
    
    @IBOutlet weak var passwordTextField: UnderLineImageTextField!
    @IBOutlet weak var passwordError: UILabel!
    
    
    @IBOutlet weak var confirmPasswordTextField: UnderLineImageTextField!
    @IBOutlet weak var confirmPasswordError: UILabel!
    
    var isTCSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTermsAndCondition()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailAddressTextField.delegate = self
        mobileNumber.delegate = self
        countryCode.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func isValid() -> Bool {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.firstNameError.isHidden = false
            return false
        }
        if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.lastNameError.isHidden = false
            return false
        }
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.emailAddressError.isHidden = false
            return false
        }
        if !(emailAddressTextField.text?.isValidEmail() ?? false) {
            self.emailAddressError.isHidden = false
            self.emailAddressError.text = "Enter a valid email address"
            return false
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.passwordError.isHidden = false
            return false
        }
        if mobileNumber.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.mobileNumberError.isHidden = false
            return false
        }
        if confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.confirmPasswordError.isHidden = false
            return false
        }
        if confirmPasswordTextField.text != passwordTextField.text {
            self.confirmPasswordError.isHidden = false
            self.passwordError.isHidden = false
            self.confirmPasswordError.text = "Password not matched!"
            self.passwordError.text = "Password not matched!"
            return false
        }
        if !isTCSelected {
            Utilities.showWarningAlert(message: "Please accept Terms & Conditions")
            return false
        }
        return true
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func registerBtnTapped(_ sender: Any) {
        if isValid() {
//            Coordinator.showOTPScreen(delegate: self)
            view.endEditing(true)
            let parameters = [
                "first_name": self.firstNameTextField.text!,
                "last_name": self.lastNameTextField.text!,
                "name" : "\(self.firstNameTextField.text!) \(self.lastNameTextField.text!)",
                "email": emailAddressTextField.text!,
                "mobile": "\(self.countryCode.text!)\(self.mobileNumber.text!)",
                "password": self.passwordTextField.text!,
                "confirm_password": self.confirmPasswordTextField.text!
            ]
            
            AuthenticationAPIManager.signupAPI(parameters: parameters) { [self] result in
                guard let result = result else {
                    return
                }
                
                switch result.status {
                case "Success":
                    Utilities.showSuccessAlert(message: result.message ?? "") {
                        Coordinator.showOTPScreen(delegate: self, registerNewUser: NewUserRegistration(email: self.emailAddressTextField.text!))
                    }
                    break
                    
                case "Fail":
                    Utilities.showSuccessAlert(message: result.message ?? "")
                default: break
                }
            }
        }
    }
    
    @IBAction func tcAccept(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = Color.darkPurple.color()
            self.isTCSelected = true
        } else {
            sender.backgroundColor = .clear
            sender.borderColor = Color.darkPurple.color()
            sender.borderWidth = 1
            sender.ibcornerRadius = 5
            self.isTCSelected = false
        }
    }
}

extension SignupViewController {
    fileprivate func setupTermsAndCondition() {
        self.tcLabel.text = self.text
        self.tcLabel.textColor =  UIColor.black
        let underlineAttriString = NSMutableAttributedString(string: self.text)
        let range1 = (self.text as NSString).range(of: "Terms & conditions")
        let range2 = (self.text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Nunito-SemiBold", size: 13)!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.customPink.color(), range: range1)
        
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Nunito-SemiBold", size: 13)!, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.customPink.color(), range: range2)
        self.tcLabel.attributedText = underlineAttriString
        self.tcLabel.isUserInteractionEnabled = true
        self.tcLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(gesture:))))
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if let label: UILabel = gesture.view as? UILabel {
            if label.text == "I accept the Terms & conditions and Privacy Policy" {
                Coordinator.showTermConditions(delegate: self)
            }
        }
    }
}


extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumber {
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            // make sure the result is under 16 characters
            return updatedText.count <= 12
        } else if textField == countryCode {
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            // make sure the result is under 16 characters
            return updatedText.count <= 4
        }
        if textField == firstNameTextField {
            self.firstNameError.isHidden = true
        }
        if textField == lastNameTextField {
            self.lastNameError.isHidden = true
        }
        if textField == emailAddressTextField {
            self.emailAddressError.isHidden = true
        }
        if textField == passwordTextField {
            self.passwordError.isHidden = true
        }
        if textField == confirmPasswordTextField {
            self.confirmPasswordError.isHidden = true
        }
        if textField == mobileNumber {
            self.mobileNumberError.isHidden = true
        }
        return true
    }
}
