//
//  LogoutViewController.swift
//  Splidu
//
//  Created by Rafi on 03/09/2022.
//

import UIKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelBtn(_ sender: Any) {
        Coordinator.dismissPopUp(delegate: self)
    }
    @IBAction func signOutBtnTapped(_ sender: Any) {
        AuthenticationAPIManager.logoutAPI { [self] result in
            switch result.status {
            case "Success":
                dismiss(animated: true) {
                    SessionManager.clearLoginSession()
                    FBSignInManager.shared.logoutFromFB()
                    Coordinator.LoginScreen()
                }
                break
            case "Failed":
                break
            default: break
            }
        }
    }
}
