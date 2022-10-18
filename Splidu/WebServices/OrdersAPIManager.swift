//
//  OrdersAPIManager.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//

import Foundation
import Alamofire
//orders

class OrdersAPIManager {
    struct GetAllOrdersConfig: APIConfiguration {
        var method: HTTPMethod = .get
        var headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "orders"
    }
    
    public class func GetAllOrders(completionHandler: @escaping(OrdersModel)->Void) {
        let config = GetAllOrdersConfig()
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(OrdersModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Get All Orders...........")
                case "Fail":
                    print("GET - Failed to Get All Orders...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Order Detail
    struct GetOrderDetailConfig: APIConfiguration {
        var method: HTTPMethod = .get
        var headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "order/"
    }
    public class func GetOrderDetail(orderId: String, completionHandler: @escaping(OrderDetailModel)->Void) {
        var config = GetOrderDetailConfig()
        config.path += orderId
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(OrderDetailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Get Order Detail...........")
                case "Fail":
                    print("GET - Failed to Get Order Detail...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: Cancel Booking Order
    struct CancelBookingConfig: APIConfiguration {
        var method: HTTPMethod = .delete
        var headers: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "order/cancel"
    }
    public class func CancelSingleBooking(params: [String:Any], completionHandler: @escaping(SuccessFailModel)->Void) {
        var config = CancelBookingConfig()
        config.parameters = params
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("DELETE - Success, Cancel Booking...........")
                case "Fail":
                    print("DELETE - Failed to Cancel Booking...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}
