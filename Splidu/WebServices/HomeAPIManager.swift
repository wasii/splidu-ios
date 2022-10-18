//
//  HomeAPIManager.swift
//  Splidu
//
//  Created by abdWasiq on 13/09/2022.
//

import Foundation
import Alamofire

class HomeAPIManager {
    
    //MARK: HOME
    struct HomeConfig: APIConfiguration {
        var headers: HTTPHeaders? = nil
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = ""
    }
    
    public class func homeAPI(completionHandler: @escaping(_ result: HomeModel) -> Void) {
        var config = HomeConfig()
        if UserDefaults.standard.string(forKey: ud_user_token) != nil {
            config.headers = [
                "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
                "Accept" : "application/json"
            ]
        }
//        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HomeModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Home API Success.........")
                    break
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
    
    //MARK: Dining Details - Underground Dining
    struct DiningConfig: APIConfiguration {
        var headers: HTTPHeaders? = nil
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "dinings"
    }
    
    public class func DiningAPI(page: String?, completionHandler: @escaping(_ result: HomeDiningModel) -> Void) {
        var config = DiningConfig()
        if let page = page {
            config.parameters = ["page": page]
        }
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HomeDiningModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Home Dining API Success - Page \(page ?? "1").........")
                    break
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
    
    //MARK: Chef
    struct ChefConfig: APIConfiguration {
        var headers: HTTPHeaders? = nil
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "chef"
    }
    
    public class func ChefAPI(chefId: Int, page: String?, completionHandler: @escaping(_ result: HomeChefModel) -> Void) {
        var config = ChefConfig()
        if let page = page {
            config.parameters = ["page": page]
        }
        config.path += "/\(chefId)"
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HomeChefModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Home CHEF API Success - Page \(page ?? "1").........")
                    break
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
    
    //MARK: Chef Detail
    struct ChefDetailConfig: APIConfiguration {
        var headers: HTTPHeaders? = nil
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "dining"
    }
    
    public class func ChefDetailAPI(chefId: Int, completionHandler: @escaping(_ result: HomeChefDetailModel) -> Void) {
        var config = ChefDetailConfig()
        config.path += "/\(chefId)"
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HomeChefDetailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Home CHEF DETAIL API Success.........")
                    break
                case "Fail":
                    print(response.status ?? "")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Booking Confirmation
    struct BookingConfirmConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
        var path: String = "booking"
    }
    
    public class func BookingConfirm(params: [String: Any], completionHandler: @escaping(_ result: SuccessFailModel) -> Void) {
        var config = BookingConfirmConfig()
        config.headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        config.parameters = params
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("POST - Booking Confirmed.........")
                    break
                case "Fail":
                    print(response.status ?? "")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Booking Attributes
    struct BookingAttributesConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "booking-attirbutes"
    }
    
    public class func GetBookingAttributes(completionHandler: @escaping(_ result: BookingAttributesModel) -> Void) {
        let config = BookingAttributesConfig()
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(BookingAttributesModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Booking Attributes.........")
                    break
                case "Fail":
                    print("GET - Failed to Get Booking Attributes.........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Add Guest Details
    struct AddGuestDetailsConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
        var path: String = "booking/"
    }
    
    public class func AddGuestDetails(parameters: [String:Any], orderId: String, completionHandler: @escaping(_ result: SuccessFailModel) -> Void) {
        var config = AddGuestDetailsConfig()
        config.headers = [
            "Accept" : "application/json"
        ]
        config.parameters = parameters
        config.path += orderId
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Add Booking Guest.........")
                    break
                case "Fail":
                    print("GET - Failed to Add Booking Guest.........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Get Underground Chefs
    struct UndergroundChefsConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "underground-chefs"
    }
    
    public class func UndergroundChefs(page: String?, completionHandler: @escaping(_ result: UndergroundChefsModel) -> Void) {
        var config = UndergroundChefsConfig()
        if let token = UserDefaults.standard.string(forKey: ud_user_token) {
            config.headers = [
                "Authorization" : "Bearer \(token)",
                "Accept": "application/json"
            ]
        }
        if let page = page {
            config.parameters = ["page": page]
        }
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UndergroundChefsModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Underground Chefs.........")
                    break
                case "Fail":
                    print("GET - Failed to Get Underground Chefs.........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Get Underground Chefs Details
    struct UndergroundChefsDetailsConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "chef"
    }
    
    public class func UndergroundChefsDetails(chefId: Int, page: String?, completionHandler: @escaping(_ result: UndergroundChefDetailModel) -> Void) {
        var config = UndergroundChefsDetailsConfig()
        if let token = UserDefaults.standard.string(forKey: ud_user_token) {
            config.headers = [
                "Authorization" : "Bearer \(token)",
                "Accept": "application/json"
            ]
        }
        if let page = page {
            config.parameters = ["page" : page]
        }
        config.path += "/\(chefId)"
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UndergroundChefDetailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Underground Chefs Details.........")
                    break
                case "Fail":
                    print("GET - Failed to Get Underground Chefs Details.........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Get Dates from selection
    struct GetSeatsFromDateConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .get
        var path: String = "dining/"
    }
    
    public class func GetSeatsFromDate(dining: Int, date: String, completionHandler: @escaping(_ result: GetSeatsFromDates) -> Void) {
        var config = GetSeatsFromDateConfig()
        if let token = UserDefaults.standard.string(forKey: ud_user_token) {
            config.headers = [
                "Authorization" : "Bearer \(token)",
                "Accept": "application/json"
            ]
        }
        config.path += "\(dining)/date/\(date)"
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GetSeatsFromDates.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Get Times from date.........")
                    break
                case "Fail":
                    print("GET - Failed to Get time from date.........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    // MARK: - Get StripeRefrence API
    struct StripeConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
        var path: String = "stripe"
    }
    
    struct StripeAPIParams {
        var amount: String
        var dictAsParams: [String: String] {
            return ["amount": amount]
        }
    }
    
    class func getStripeRefrenceAPI(params: StripeAPIParams, completionHandler: @escaping(_ result: StripeApiResponse?) -> Void) {
        var config = StripeConfig()
        config.parameters = params.dictAsParams
        if let token = UserDefaults.standard.string(forKey: ud_user_token) {
            config.headers = [
                "Authorization" : "Bearer \(token)",
                "Accept": "application/json"
            ]
        }
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(StripeApiResponse?.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}
