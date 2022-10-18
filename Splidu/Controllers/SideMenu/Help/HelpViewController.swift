//
//  HelpViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class HelpViewController: BaseViewController {

    @IBOutlet weak var nameTextField: UnderLineImageTextField!
    @IBOutlet weak var emailTextField: UnderLineImageTextField!
    @IBOutlet weak var countryCodeTextField: UnderLineImageTextField!
    @IBOutlet weak var mobileNumberTextField: UnderLineImageTextField!
    @IBOutlet weak var messageTextField: UnderLineImageTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Help"
        
        countryCodeTextField.delegate = self
        mobileNumberTextField.delegate = self
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if !emailTextField.text!.isValidEmail() {
            return
        }
        if countryCodeTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if messageTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        
        let parameter = [
            "name": nameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "mobile_number" : "\(countryCodeTextField.text ?? "")\(mobileNumberTextField.text ?? "")",
            "message" : messageTextField.text ?? ""
        ]
        SideMenuAPIManager.SubmitHelp(parameters: parameter) { model in
            switch model.status {
            case "Success":
                Utilities.showSuccessAlert(message: model.message ?? "") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                break
            case "Fail":
                Utilities.showWarningAlert(message: model.message ?? "")
                break
            default: break
            }
        }
    }
    
}

extension HelpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumberTextField {
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            // make sure the result is under 16 characters
            return updatedText.count <= 12
        } else if textField == countryCodeTextField {
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            // make sure the result is under 16 characters
            return updatedText.count <= 4
        }
        return true
    }
}
