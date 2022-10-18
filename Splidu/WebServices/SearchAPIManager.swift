//
//  SearchAPIManager.swift
//  Splidu
//
//  Created by Wasiq Saleem on 16/09/2022.
//

import Foundation
import Alamofire

class SearchAPIManager {
    struct GetSearchConfig: APIConfiguration {
        var method: HTTPMethod = .get
        var headers: HTTPHeaders = [
            "Accept" : "application/json"
        ]
        var parameters: [String : Any] = [:]
        var path: String = "search"
    }
//    public class func GetSearch(page: String)
}
