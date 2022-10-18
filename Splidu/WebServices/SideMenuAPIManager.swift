//
//  SideMenuAPIManager.swift
//  Splidu
//
//  Created by NaheedPK on 15/09/2022.
//

import Foundation
import Alamofire

class SideMenuAPIManager {
    
    //MARK: Submit HELP
    struct SubmitHelpConfig: APIConfiguration {
        var method: HTTPMethod = .post
        var headers: HTTPHeaders = [
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "help"
    }
    
    public class func SubmitHelp(parameters: [String:String], completionHandler: @escaping(SuccessFailModel)->Void) {
        var config = SubmitHelpConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch response.status {
                case "Success":
                    print("POST - Success,  Query Submitted...........")
                case "Fail":
                    print("POST - Failed to Submit query...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //MARK: CMS PAGES
    struct GetCMSPagesConfig: APIConfiguration {
        var method: HTTPMethod = .get
        var headers: HTTPHeaders = [:]
        var parameters: [String : Any] = [:]
        var path: String = "page/"
    }
    public class func GetCMSPages(type: String, completionHandler: @escaping(CMSPagesModel) -> Void) {
        var config = GetCMSPagesConfig()
        config.path += type
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(CMSPagesModel.self, from: json)
                switch response.status {
                case "Success":
                    print("GET - Success, Get \(type)...........")
                case "Fail":
                    print("GET - Failed to Get \(type)...........")
                default: break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}
