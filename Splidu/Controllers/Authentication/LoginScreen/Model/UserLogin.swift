//
//  UserLogin.swift
//  Splidu
//
//  Created by abdWasiq on 12/09/2022.
//

import Foundation

struct GeneericResponseModel: Codable {
    let code: Int?
    let message: String?
    let status: String?
   
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case status
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}

struct UserLogin: Codable {
    let baseURL: String?
    let code: Int?
    let message: String?
    let status: String?
    let token: String?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case code
        case message
        case status
        case token
        case user
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baseURL = try values.decodeIfPresent(String.self, forKey: .baseURL)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }
}

struct User: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let mobile: String?
    let userImage: String?
    let fbLink: String?
    let inLink: String?
    let twLink: String?
    let liLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case mobile
        case userImage = "user_image"
        case fbLink = "fb_link"
        case inLink = "in_link"
        case twLink = "tw_link"
        case liLink = "li_link"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        userImage = try values.decodeIfPresent(String.self, forKey: .userImage)
        fbLink = try values.decodeIfPresent(String.self, forKey: .fbLink)
        inLink = try values.decodeIfPresent(String.self, forKey: .inLink)
        twLink = try values.decodeIfPresent(String.self, forKey: .twLink)
        liLink = try values.decodeIfPresent(String.self, forKey: .liLink)
    }
}
