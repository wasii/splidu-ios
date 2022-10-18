//
//  Constants.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import Foundation
import UIKit

var tempImage: UIImage?

//Strings
//ADD GUEST DETAILS
let fullName = "Full Name"
let age = "Age"
//DIETARY
let restrictions = "Search and add dietary restrictions"
let dislikes = "Dont like something? Please mention"
//BOOKING
let constantCommentsForChef = "Add you notes here......."
let constantPromoCode = "Add Your code here......"
let constantPayUsingWallet = "Enter the amount from wallet"

struct Storyboards {
    static let Authentication = "Authentication"
}

//MARK: APIKey Constant
let code = "code"
let message = "message"
let status = "status"
let token = "token"

//USERDEFAULTS Constant Keys
let ud_user_token: String = "user_token"
let ud_user_id: String = "user_id"

class Constants {
    static let shared: Constants = Constants()
    static let googleSignInID = "493040239530-gh25alb73gejc9u10lhpr6k85vq9a4jt.apps.googleusercontent.com"
    static let baseURL: String = "https://jarsite.com/splidu/api/v1/"
    static let headers: [(String, String)] = [
        ("Authorization", UserDefaults.standard.string(forKey: ud_user_token) ?? "")
//        ("Content-Type", "application/json")
    ]
    
    static let stripeKey = "pk_test_51KdqxdBjsMxFtgBeSKmSXVjwG6yqKIUT89jWGFrZcON2gxqhtfhH6EFSHYVdrqPAU4UxEsIlAUEhnmPAlkvxMkzK0009RlNxWJ"
}
