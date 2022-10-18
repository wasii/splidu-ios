//
//  APIConfiguration.swift
//  Splidu
//
//  Created by abdWasiq on 12/09/2022.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var url: URL { get }
    var parameters: [String: Any] { get }
    var headers: HTTPHeaders { get }
}
protocol UploadAPIConfiguration: APIConfiguration {
    var images: [String: [UIImage?]] { get set }
}

extension APIConfiguration {
    var headers: HTTPHeaders {
        var tempHeaders: HTTPHeaders = HTTPHeaders()
        if let token = UserDefaults.standard.string(forKey: ud_user_token) {
            tempHeaders = [
                "Authorization" : "Bearer \(token)",
                "Accept" : "application/json"
            ]
        }
        return tempHeaders
    }
    
    var url: URL {
        let baseURL = URL(string: Constants.baseURL)!
        return baseURL.appendingPathComponent(path)
    }
    func asURLRequest() throws -> URLRequest {
        let baseURL = URL(string: Constants.baseURL)!

        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

//        Constants.headers.forEach { (field, value) in
//            urlRequest.addValue(value, forHTTPHeaderField: field)
//        }

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            throw AFError.parameterEncoderFailed(reason: AFError.ParameterEncoderFailureReason.encoderFailed(error: error))
        }

        return urlRequest
    }
}
