//
//  FBSignIn~Manager.swift
//  Splidu
//
//  Created by Muneeb on 23/09/2022.
//

import Foundation
import FacebookLogin
import FacebookCore

struct FBResponseHandler {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
}

class FBSignInManager {
    
    static let shared = FBSignInManager()
    let loginManager = LoginManager()
    
    func signInWithFaceBook(selfVC: UIViewController, completionHandler: @escaping(_ result: FBResponseHandler?) -> Void) {
        
        loginManager.logIn(permissions: ["public_profile"], from: selfVC) { result, error in
            Utilities.showIndicatorView()
            if let error = error {
                Utilities.hideIndicatorView()
                print("Encountered Erorr: \(error)")
                Utilities.showWarningAlert(message: error.localizedDescription)
                completionHandler(nil)
                
            } else if let result = result, result.isCancelled {
                print("Cancelled")
                Utilities.hideIndicatorView()
                completionHandler(nil)
                
            } else {
                Utilities.hideIndicatorView()
                print("Logged In")
                if result?.token != nil {
                    GraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, email, name"]).start { connection, result, error in
                        if let result = result {
                            print("Fetched Result: \(result)")
                            if let responseDict = result as? [String: String] {
                                let firstName = (responseDict["first_name"] ?? "")
                                let lastName = (responseDict["last_name"] ?? "")
                                let email = (responseDict["email"] ?? "")
                                
                                let fbResponseHandler = FBResponseHandler(id: responseDict["id"]!, firstName: firstName, lastName: lastName, email: email)
                                completionHandler(fbResponseHandler)
                            }
                        } else {
                            Utilities.hideIndicatorView()
                            Utilities.showWarningAlert(message: "Unable to sign in please try again.")
                            completionHandler(nil)
                        }
                    }
                }
            }
        }
    }
    
    func logoutFromFB() {
        loginManager.logOut()
    }
}
