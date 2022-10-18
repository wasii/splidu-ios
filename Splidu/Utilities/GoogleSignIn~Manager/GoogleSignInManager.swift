//
//  GoogleSignInManager.swift
//
//  Created by Muneeb on 30/08/2021.
//

import Foundation
import GoogleSignIn

protocol GoogleSignIn: AnyObject {
    func didLoginWithGoogle(user: GIDGoogleUser)
    func didFailToLoginWithGoogle(error: Error)
}
class GoogleSignInManager {
    
    static let shared = GoogleSignInManager()
    weak var googleSignInDelegate: GoogleSignIn?
    let signInConfig = GIDConfiguration.init(clientID: Constants.googleSignInID)
}

extension GoogleSignInManager {
    
    func signInWithGoogle(presentingController: UIViewController) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presentingController) { [self] user, error in
            guard error == nil else {
                googleSignInDelegate?.didFailToLoginWithGoogle(error: error!)
                return
            }
            guard let user = user else { return }
            googleSignInDelegate?.didLoginWithGoogle(user: user)
        }
    }
}
