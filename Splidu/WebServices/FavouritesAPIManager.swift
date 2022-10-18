//
//  FavouritesAPIManager.swift
//  Splidu
//
//  Created by abdWasiq on 13/09/2022.
//

import Foundation
import Alamofire


class FavouritesAPIManager {
    
    //MARK: Favourite Chef
    struct FavouritesChefConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var path: String = "favorites"
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
    }
    
    public class func GetFavouritesChef(parameter: [String:Any], completionHandler: @escaping(FavouritesChefModel) -> Void) {
        var request = FavouritesChefConfig()
        request.headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        request.parameters = parameter
        APIClient.apiRequest(request: request) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let favChef = try JSONDecoder().decode(FavouritesChefModel.self, from: json)
                switch favChef.status {
                case "Success":
                    print("Favourite Chef API Success.........")
                    break
                case "Failed":
                    break
                default: break
                }
                completionHandler(favChef)
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    public class func GetFavouritesDining(parameter: [String:String], completionHandler: @escaping(FavouriteDiningModel) -> Void) {
        var request = FavouritesChefConfig()
        request.headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        request.parameters = parameter
        APIClient.apiRequest(request: request) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let favDining = try JSONDecoder().decode(FavouriteDiningModel.self, from: json)
                switch favDining.status {
                case "Success":
                    print("Favourite Dining API Success.........")
                    break
                case "Failed":
                    break
                default: break
                }
                completionHandler(favDining)
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    //MARK: Remove Favourite Chef
    struct RemoveFavouritesChefConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var path: String = "favorite"
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .delete
    }
    
    public class func RemoveFavouritesChef(params: [String:Any], completionHandler: @escaping(RemoveFavouriteChef) -> Void) {
        var request = RemoveFavouritesChefConfig()
        request.headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        request.parameters = params
        APIClient.apiRequest(request: request) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let favChef = try JSONDecoder().decode(RemoveFavouriteChef.self, from: json)
                switch favChef.status {
                case "Success":
                    
                    break
                case "Failed":
                    break
                default: break
                }
                completionHandler(favChef)
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    //MARK: Remove Favourite Chef
    struct AddFavouritesConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var path: String = ""
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .post
    }
    
    public class func AddFavourites(paramater: [String:Any], completionHandler: @escaping(SuccessFailModel) -> Void) {
        var request = AddFavouritesConfig()
        request.headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        request.path = "favorite"
        request.parameters = paramater
        APIClient.apiRequest(request: request) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let favChef = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch favChef.status {
                case "Success":
                    
                    break
                case "Failed":
                    break
                default: break
                }
                completionHandler(favChef)
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    //MARK: Remove Favourite Chef
    struct RemoveChefFavoriteConfig: APIConfiguration {
        var headers: HTTPHeaders = [:]
        var path: String = ""
        var parameters: [String : Any] = [:]
        var method: HTTPMethod = .delete
    }
    
    public class func RemoveChefFavorite(parameters: [String:Any], completionHandler: @escaping(SuccessFailModel) -> Void) {
        var request = RemoveFavouritesChefConfig()
        request.headers = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: ud_user_token)!)",
            "Accept" : "application/json"
        ]
        request.parameters = parameters
        request.path = "favorite"
        APIClient.apiRequest(request: request) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let favChef = try JSONDecoder().decode(SuccessFailModel.self, from: json)
                switch favChef.status {
                case "Success":
                    break
                case "Failed":
                    break
                default: break
                }
                completionHandler(favChef)
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
}
