//
//  AuthenticationAPIManager.swift
//  Splidu
//
//  Created by abdWasiq on 12/09/2022.
//

import Foundation
import Alamofire
class AuthenticationAPIManager {
    
    //MARK: LOGIN
    struct LoginConfig: APIConfiguration {
        var headers: HTTPHeaders? = nil
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
        var path: String = "login"
    }
    
    public class func loginAPI(parameters: [String:String], completionHandler: @escaping(_ result: UserLogin) -> Void) {
        var config = LoginConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserLogin.self, from: json)
                switch response.status {
                case "Success":
                    guard let token = result?[token] as? String else { return }
//                    guard let id = re
                    UserDefaults.standard.set(token, forKey: ud_user_token)
                    SessionManager.setUserData(dictionary: result)
               
                case "Fail":
                    print(result?[message] as? String ?? "")
                    
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //MARK: Signup
    struct SignupConfig: APIConfiguration {
        var headers: HTTPHeaders? = nil
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
        var path: String = "signup"
    }
    
    class func signupAPI(parameters: [String: String], completionHandler: @escaping(_ result: UserLogin?) -> Void) {
        var config = SignupConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserLogin?.self, from: json)
                completionHandler(response)
                
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    //MARK: LOGOUT
    struct LogoutConfig: APIConfiguration {
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
        var path: String = "logout"
    }
    
    class func logoutAPI(completionHandler: @escaping(_ result: UserLogin) -> Void) {
        var config = LogoutConfig()
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserLogin.self, from: json)
                switch response.status {
                case "Success":
                    print(result?[message] as? String ?? "")
                case "Fail":
                    print(result?[message] as? String ?? "")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    // MARK: - Social Login API
    struct SocialMediaLoginConfig: APIConfiguration {
        var parameters: [String: Any] = [:]
        var method: HTTPMethod = .post
        var path = "social-signup"
    }
    
    struct SocialMediaLoginApiParams {
        var firstName: String
        var lastName: String
        var email: String
        var socialKey: String
        
        var dictAsParams: [String: String] {
            return ["first_name": firstName,
                    "last_name": lastName,
                    "email": email,
                    "social_id": socialKey]
        }
    }
    
    class func socialLoginApi(params: SocialMediaLoginApiParams, completionHandler : @escaping(_ result: UserLogin?) -> Void) {
        var config = SocialMediaLoginConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserLogin.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    // MARK: - Verify OTP API
    struct OTPConfig: APIConfiguration {
        var parameters: [String: Any] = [:]
        var method: HTTPMethod = .post
        var path = "verify-opt"
    }
    
    struct VerifyOTPApiParams {
        var email: String
        var otp: String
        var type: String = "Development"
        
        var dictAsParams: [String: String] {
            return ["email": email,
                    "otp": otp,
                    "type": type]
        }
    }
    
    class func verifyOTPApi(params: VerifyOTPApiParams, completionHandler : @escaping(_ result: UserLogin?) -> Void) {
        var config = OTPConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserLogin.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    
    // MARK: - ForgotPassword Verify OTP API
    struct ForgotPasswordOTPApiParams {
        var email: String
        var otp: String
        var verify_type: String
        var otp_type: String
        var mobile: String
        var dictAsParams: [String: String] {
            return ["email": email,
                    "otp": otp,
                    "verify_type": verify_type,
                    "otp_type": otp_type,
                    "mobile": mobile,
                    "type": "Development"]
        }
    }
    
    class func verifyForgotPasswordOTPApi(params: ForgotPasswordOTPApiParams, completionHandler : @escaping(_ result: GeneericResponseModel?) -> Void) {
        var config = OTPConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    // MARK: - Resend OTP API
    struct ResendOTPConfig: APIConfiguration {
        var parameters: [String: Any] = [:]
        var method: HTTPMethod = .post
        var path = "resend-opt"
    }
    
    struct ResendOTPApiParams {
        var email: String
        var dictAsParams: [String: String] {
            return ["email": email]
        }
    }
    
    class func resendOTPApi(params: ResendOTPApiParams, completionHandler : @escaping(_ result: GeneericResponseModel?) -> Void) {
        var config = ResendOTPConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    struct ForgotPasswordResendOTPApiParams {
        var email: String
        var otp_type: String
        var type: String
        
        var dictAsParams: [String: String] {
            return ["email": email,
                    "otp_type": otp_type,
                    "type": type]
        }
    }
    
    class func forgotPasswordResendOTPApi(params: ForgotPasswordResendOTPApiParams, completionHandler : @escaping(_ result: GeneericResponseModel?) -> Void) {
        var config = ResendOTPConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    // MARK: - Forgot Password API
    struct ForgotPasswordConfig: APIConfiguration {
        var parameters: [String: Any] = [:]
        var method: HTTPMethod = .post
        var path = "forgot-password"
    }
    
    struct ForgotPasswordApiParams {
        var email: String
        var mobile: String
        var type: String
        var dictAsParams: [String: String] {
            return ["email": email,
                    "mobile": mobile,
                    "type": type]
        }
    }
    
    class func forgotPasswordApi(params: ForgotPasswordApiParams, completionHandler : @escaping(_ result: GeneericResponseModel?) -> Void) {
        var config = ForgotPasswordConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    // MARK: - Verify Mobile OTP
    struct VerifyMobileOTPApiParams {
        var otp: String
        var mobile: String
        var socialID: String
        var dictAsParams: [String: String] {
            return ["email": "",
                    "otp": otp,
                    "verify_type": "",
                    "otp_type": "mobile",
                    "mobile": mobile,
                    "type": "Development",
                    "social_id": socialID]
        }
    }
    
    class func verifyMobileOTPApi(params: VerifyMobileOTPApiParams, completionHandler : @escaping(_ result: UserLogin?) -> Void) {
        var config = OTPConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserLogin?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
    
    // MARK: - Mobile OTP API
    struct MobileOTPConfig: APIConfiguration {
        var parameters: [String: Any] = [:]
        var method: HTTPMethod = .post
        var path = "mobile-otp"
    }
    
    struct MobileOTPApiParams {
        var social_id: String
        var mobile: String
        var dictAsParams: [String: String] {
            return ["social_id": social_id,
                    "mobile": mobile]
        }
    }
    
    class func sendMobileOTPApi(params: MobileOTPApiParams, completionHandler : @escaping(_ result: GeneericResponseModel?) -> Void) {
        var config = MobileOTPConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
                completionHandler(nil)
            }
        }
    }
}
