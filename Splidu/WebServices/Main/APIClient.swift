//
//  APIClient.swift
//  Splidu
//
//  Created by abdWasiq on 12/09/2022.
//

import Foundation
import Alamofire

enum APIError {
    static var accountSuspensionMsg = "Your account is either suspended or currently being used in other device. Please login again to proceed further."
}

class APIClient {
    class func printDetailedError(responseData: Data?, error: Error) {
        print("\n\n===========Error===========")
        print("Error Code: \(error._code)")
        print("Error Messsage: \(error.localizedDescription)")
        if let data = responseData, let str = String(data: data, encoding: String.Encoding.utf8){
            print("Server Error: " + str)
        }
        debugPrint(error as Any)
        print("===========================\n\n")
    }
    
    class func codableAPIRequest<T>(request: APIConfiguration, completionHandler: @escaping(_ result: T?) -> Void) where T:Codable {
        Utilities.showIndicatorView()
        AF.request(
            request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: URLEncoding.default,
            headers: request.headers
        ).validate(statusCode: 200..<500)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                Utilities.hideIndicatorView()
                
                switch response.response?.statusCode {
                case 401:
                    guard let reponseDict = response.value as? NSDictionary, let message = reponseDict[message] as? String else {
                        //                        sessionExpiredAction(message: "Session expired. Please login again.")
                        return
                    }
                    //                    sessionExpiredAction(message: message)
                default:
                    switch response.result {
                    case .success(let data):
                        completionHandler(data)
                    case .failure(let error):
                        printDetailedError(responseData: response.data, error: error)
                        if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorNotConnectedToInternet {
                            //                            Utilities.showWarningAlert(message: "No Internet connection available")
                        } else if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorTimedOut {
                            //                            Utilities.showWarningAlert(message: "Request Timed Out")
                        }  else if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorNetworkConnectionLost {
                            //                            Utilities.showWarningAlert(message: "Internet connection lost")
                        } else if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorDataNotAllowed {
                            //                              Utilities.showWarningAlert(message: "No Internet connection available")
                        } else {
                            //                            Utilities.showWarningAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
    }
    
    class func apiRequest(request: APIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        Utilities.showIndicatorView()
        AF.request(request.url, method: request.method, parameters: request.parameters, encoding: URLEncoding.default, headers: request.headers).validate(statusCode: 200..<500).responseJSON { response in
            
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    completionHandler(nil)
                    return
                }
                Utilities.showWarningAlert(message: APIError.accountSuspensionMsg) {
                    SessionManager.clearLoginSession()
                    Coordinator.LoginScreen()
                }
                //                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                    
                case .failure(let error):
                    printDetailedError(responseData: response.data, error: error)
                    if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorNotConnectedToInternet {
                        Utilities.showWarningAlert(message: "No internet connection")
                    } else {
                        Utilities.showWarningAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    class func multiPartRequest(request: UploadAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        AF.upload(multipartFormData: { multipartFormData in
            for (imageKey, images) in request.images {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "images\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in request.parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
        },
                  to: request.url,
                  method: request.method,
                  headers: request.headers).responseJSON { response in
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
//                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
//                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    printDetailedError(responseData: response.data, error: error)
                    if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorNotConnectedToInternet {
                        Utilities.showWarningAlert(message: "No internet connection")
                    } else {
                        Utilities.showWarningAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
