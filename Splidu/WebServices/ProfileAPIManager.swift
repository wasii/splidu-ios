//
//  ProfileAPIManager.swift
//  Splidu
//
//  Created by abdWasiq on 14/09/2022.
//

import Foundation
import Alamofire

class ProfileAPIManager {
    
    //MARK: Change Password
    struct ChangePasswordConfig: APIConfiguration {
        var method: HTTPMethod = .post
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "change-password"
    }
    public class func ChangePassword(parameters: [String:String], completionHandler: @escaping(ChangePasswordModel)->Void) {
        var config = ChangePasswordConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChangePasswordModel.self, from: json)
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
    
    //MARK: Update  Password
    struct UpdatePasswordConfig: APIConfiguration {
        var method: HTTPMethod = .post
        var parameters: [String : Any] = [:]
        var path: String = "new-password"
    }
    
    public class func updateNewPassword(parameters: [String: String], completionHandler: @escaping(GeneericResponseModel)->Void) {
        var config = UpdatePasswordConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: LOCATION
    // Get All Locations
    struct GetAllLocationsConfig: APIConfiguration {
        var method: HTTPMethod = .get
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "locations"
    }
    public class func GetAllLocations(completionHandler: @escaping(GetAllLocationModel)->Void) {
        let config = GetAllLocationsConfig()
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GetAllLocationModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success,  Get All Locations...........")
                case "Fail":
                    print("GET - Failed to Get All Locations...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //Delete Location
    struct DeleteLocationConfig: APIConfiguration {
        var method: HTTPMethod = .delete
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "location/"
    }
    public class func DeleteLocation(id: String, completionHandler: @escaping(SuccessFailModel)->Void) {
        var config = DeleteLocationConfig()
        config.path += id
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("DELETE - Success,  Location Delete Against \(id) ID...........")
                case "Fail":
                    print("DELETE - Failed to Delete Location Against \(id) ID...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //Delete Location
    struct ChangeLocationStatusConfig: APIConfiguration {
        var method: HTTPMethod = .put
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "location-status"
    }
    public class func ChangeLocationStatus(paramaters: [String:Any], completionHandler: @escaping(SuccessFailModel)->Void) {
        var config = ChangeLocationStatusConfig()
        config.parameters = paramaters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("PUT - Success,  Location Status Change...........")
                case "Fail":
                    print("PUT - Failed to Update Location Status...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //Add New Location
    struct AddNewLocationConfig: APIConfiguration {
        var method: HTTPMethod = .post
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "location"
    }
    public class func AddNewLocation(id: Int?, paramaters: [String:String], completionHandler: @escaping(SuccessFailModel)->Void) {
        var config = AddNewLocationConfig()
        config.parameters = paramaters
        //This check is used for UPDATE Address, If ID present, Update Address will call
        if let id = id {
            config.path += "/\(id)"
            config.method = .put // Change this method for the update address call. Update Address supports PUT Method.
        }
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    if let id = id {
                        print("POST - Update Location against \(id)...........")
                    } else {
                        print("POST - Success,  Add New Location...........")
                    }
                case "Fail":
                    if let id = id {
                        print("POST - Failed to Update Location against \(id)...........")
                    } else {
                        print("POST - Failed to Add New Location...........")
                    }
                    
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Profile
    struct GetMyProfileConfig: APIConfiguration {
        var method: HTTPMethod = .get
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "get-profile/"
    }
    public class func GetMyProfile(userId: Int, completionHandler: @escaping(MyProfileModel)->Void) {
        var config = GetMyProfileConfig()
        config.path += "\(userId)"
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyProfileModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Get My Profile...........")
                case "Fail":
                    print("GET - Failed to Get My Profile...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Update Profile
    struct UpdateMyProfileConfig: UploadAPIConfiguration {
        var images: [String : [UIImage?]]
        var method: HTTPMethod = .post
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "manage-profile"
    }
    public class func UpdateMyProfile(images:[String : [UIImage?]], params: [String:Any], completionHandler: @escaping(SuccessFailModel)->Void) {
        var config = UpdateMyProfileConfig(
            images : images
        )
        config.parameters = params
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Get My Profile...........")
                case "Fail":
                    print("GET - Failed to Get My Profile...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
//        APIClient.apiRequest(request: config) { result in
//            do {
//                let json = try JSONSerialization.data(withJSONObject: result as Any)
//                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
//                switch response.status {
//                case "Success":
//                    print("GET - Success, Get My Profile...........")
//                case "Fail":
//                    print("GET - Failed to Get My Profile...........")
//                default: break
//                }
//                completionHandler(response)
//            } catch let err {
//                print(err)
//            }
//        }
    }
    
    // MARK: -  Get Wallet
    struct GetMyWalletConfig: APIConfiguration {
        var method: HTTPMethod = .get
//        var headers: HTTPHeaders = [
//            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
//            "Accept" : "application/json"
//        ]
        var parameters: [String : Any] = [:]
        var path: String = "my-wallet"
    }
    
    public class func GetMyWallet(completionHandler: @escaping(MyWalletModel)->Void) {
        let config = GetMyWalletConfig()
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyWalletModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    // MARK: -  Add Wallet Config
    struct AddWalletConfig: APIConfiguration {
        var method: HTTPMethod = .post
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "add-funds"
    }
    
    struct AddWalletApiParams {
        var amount: String
        var dictAsParams: [String: String] {
            return ["amount": amount]
        }
    }
    
    public class func addMyWallet(params: AddWalletApiParams, completionHandler: @escaping(MyWalletModel?) -> Void) {
        var config = AddWalletConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyWalletModel?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    // MARK: - Wallet Transfer Config
    struct WalletTransferConfig: APIConfiguration {
        var method: HTTPMethod = .post
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: ud_user_token) ?? "")",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "funds-transfer"
    }
    
    struct WalletTransferApiParams {
        var amount: String
        var walletID: String
        var dictAsParams: [String: String] {
            return ["amount": amount,
                    "wallet_id": walletID]
        }
    }
    
    public class func walletTransfer(params: WalletTransferApiParams, completionHandler: @escaping(GeneericResponseModel?) -> Void) {
        var config = WalletTransferConfig()
        config.parameters = params.dictAsParams
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GeneericResponseModel?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}
